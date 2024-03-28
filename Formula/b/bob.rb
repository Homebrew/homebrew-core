class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "c8bbedae685520ad79aa3adb268db0cc79999e1a4f3c20b902100fe9cc3ea34c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f80d5e8b0c1ae7583516b4a3614c3c19dd6311307a193dc66c2dad387e20fedb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b6da8992c9790e6d535b8bb013f9554703e7eb9090ed6c2ea7127594e13d713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2ddd22412377f8dd0e7dbe485275c1c50f1a60853741ebfd0e9179e2b077d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7205a2ff8a39841555657bc807b735c40f45732bb25942c7a7310b6038a8eb0e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ddad1d72b0e3349fbb2b7aa3423ad5476be1d524c0b77fcd0eee2fe243b55c7"
    sha256 cellar: :any_skip_relocation, monterey:       "84d75cef7da3e8597343b34605cbdc9903c57ec319eb51765c3613010cacb07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae6eb96b9b3915f16e74c2c71f0a00b7874e9cea1852934bd6fd8b448fc98758"
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
