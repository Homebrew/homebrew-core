class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.3.0.tar.gz"
  sha256 "ac93c88af504a93daa960363dc2fb20be54fadfc08c4ba5ad6eed9536d320e01"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d1f52db30c4e6789e1350590f7cae07b8eebb54b0ce452e74edf2928df384ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09a6c527926c051537063509c8a7349a8e7f9d129efddbd8ea4cb69ab15234b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d1a063f4b6581552c487c91d327f6945b8422a4c6b2411247318a24cd31a966"
    sha256 cellar: :any_skip_relocation, ventura:        "93b1c2d8eec6ffca41a3dbc8eebf3efb0e6a4408af4179b594bae8eb936f489a"
    sha256 cellar: :any_skip_relocation, monterey:       "7e28d4b1c632059ffb3cc225ac0ab72ddc1cc2f4cbb79f12f78e57001063d5b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "22e6f3e2712763c598fbf577877c2e8c859f3e53b9883655c85d7f1ad4bfadfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e79105553b8a97c67cf4f9dae494ffbf67202f9876f773f69973f0e5e93a65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
