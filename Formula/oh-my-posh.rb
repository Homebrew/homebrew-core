class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.3.0.tar.gz"
  sha256 "931fc257d76e01991ac7264323b538f1bd5bcca80c3729703941731917517be3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8404a998638ea357bb5ca5edaec78869ef18d03110737bbc77a647b59118e32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9abab838bd3cbf64f31d7a2f5b6c5e9381ac421042c4575e0230d2e6562ad463"
    sha256 cellar: :any_skip_relocation, monterey:       "3734c93256d1f3c0e81b5004a2785a8f437050887cd3a4926b98057b01e1f707"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec1d603206872c9305821838fdfda49fb6eeb1b3cd73ed0ee0c32e22307e28d"
    sha256 cellar: :any_skip_relocation, catalina:       "b59ca5173f7b5ac6c7d2c9f0411d32b0bc5724273b7458d2dd5d0a72d2cf8e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b138b46c8644e21ecb6e0a0a80be60c5ec3e2d45a07de7cb811cdd098f72d002"
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
