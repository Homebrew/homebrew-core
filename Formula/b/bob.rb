class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "1f026e303bf79274da0ef2ad72ea5de3d3b75001fc17998437f9e3ce2ce87454"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2ce9fe5b3f78f2e5528cc04de2e4b086a5adee9ee139b153f79d50a8ebb4b3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b07709a4646b4ab5fa8fe53a86e0789e6b83ae3cad2b6e51190c9d10d5763c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14343a61594aea0fa8bf60db1870cc2bba3ac02e6973b967cf543e8322949abf"
    sha256 cellar: :any,                 arm64_linux:       "cb1c369dbdd6706425db6247905342b670d23f1c14e2006f9d44219ca94cc539"
    sha256 cellar: :any,                 x86_64_linux:      "8ab8550262dd5c1042262d8cdfcdf206ba8cf8994fde4fcaf99b285d89f1ff9a"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bob", "complete")
    # For powershell, `power-shell` is required
    (pwsh_completion/"_bob.ps1").write Utils.safe_popen_read(bin/"bob", "complete", "power-shell")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~JSON
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    JSON

    ENV["BOB_CONFIG"] = config_file
    mkdir_p testpath/".local/share/bob"
    mkdir_p testpath/".local/share/nvim-bin"

    neovim_version = "v0.11.0"
    system bin/"bob", "install", neovim_version
    assert_match neovim_version, shell_output("#{bin}/bob list")
    assert_path_exists testpath/".local/share/bob"/neovim_version

    # failed to run `bob erase` in linux CI
    # upstream bug report, https://github.com/MordechaiHadad/bob/issues/287
    system bin/"bob", "erase" unless OS.linux?
  end
end
