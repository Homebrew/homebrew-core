class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "623b4482c2ea5c0d89251190a9e2f717270adab7090b5b05efcb17b4d2b2b854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90cb2d4d474ac5e12daea1cdaf25232aebac52d8380002150c2c24122dbca3c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56af843f473581df1ba0a06091fc7ed9bd4fc22a91b3f0ce24faa1e457a961eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e65e4d6b7459e1cc5ac7108f6cd09dc0cf1ce824529169de00445032a77fc9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bdd7c6159ab6f097c3d47974a47b6cb7325f352a0aafef6170193d858bb64db"
    sha256 cellar: :any_skip_relocation, ventura:        "82f67d49b2bafe42f7f8bacf44f3d89ac0f9df509299956e036ff96af26a880f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f81591b0278075f176b3d2c9dfc74d057184665ded8bcca7318d2ead66d3aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec7fdee436ef845e91cb5f3914d212ae6e26f28865bc99bbfca03b310ebc9da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system "#{bin}/bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system "#{bin}/bob", "erase"
  end
end
