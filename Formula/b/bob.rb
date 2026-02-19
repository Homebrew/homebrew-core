class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "c74a6b3950e297b3b013ee7586a784af05c014b8c84b78f3730538df4e1d4775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de3f7f7d11e61ecb04e2ee99a314fbee20fab0f77767cf603e14aad61f98c46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7dca5b4209bbeb4d36f5d593bacc92d6a2c7ab03577ea0afd03ad4ee557abc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24caf97d5032cedfb8bc3cd4d18a6d4acbe0d428185b4af653691873e236e77b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a427685b9b5ed8ecbfc9fd6c0f8a574a3474ee60c6a5c5858a5088d1cc6149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d881e5d7ab658baba140e0476e7acc2bcffb3e55bc8775c2fd1b9ecf3297218d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a3d6ea3dd4af3a4e03836e07ffa1b6907fb6115c9e49f7e4e4155638cea7074"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
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
