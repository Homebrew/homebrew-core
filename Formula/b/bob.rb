class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "eec4a76b145ab8cfb29cc4aa3fa668747050bd253f92667445583d19e9ea5aaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd90497207ba028e478e3dc50a2519efc4d7f31b709b5998f2477392ac09708a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f3deae32c62fca270824371673c1478166602800c0bc1de02251ee9f54d3986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50660ea59f42b39c0da514adc6eca4724efd25260a3a682b818b3fcd4a8af722"
    sha256 cellar: :any,                 arm64_linux:       "05085e0ffa97c687e8bf7481611c0efb84cde39f6d44f73096aac5e3b5bbbd7c"
    sha256 cellar: :any,                 x86_64_linux:      "71db234865a9f1530b9e4fa6078d8f82d493c302928650c95996112ce2c19828"
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
