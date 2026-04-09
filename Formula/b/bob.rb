class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "c74a6b3950e297b3b013ee7586a784af05c014b8c84b78f3730538df4e1d4775"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7e96e9ff2eebd5a54c95854f5da07ae9dee77305f42981e34b52fbba648460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5e788b434e34ecae6605eae401ea54951e1150c7bc5db61474ba8eeb8e0f06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "054de84ed6a50ae0b352536cbfe121e22325ab9f948846e7e233f9cd83e68615"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7113e46db37b115bbdc484fde5cd9589968a98e1a8869bc51c091873c0af655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "069ee6be3dc2a0c03d344796db1d205b1cf083fb43488205e1909eee6f060396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cde0e7cf21f19fcee01e31c233c9b0daec7b68465d66654553d448108dd977"
  end

  depends_on "rust" => :build

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
