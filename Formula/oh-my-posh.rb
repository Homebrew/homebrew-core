class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.1.1.tar.gz"
  sha256 "3870644702043841325e8dec62367e99bdce20780d7896e55eb87bb48989ac58"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6afb432dd98a0646751c78a92e891dc2e773f44af5c978ee467d26563f0e14c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c8bee69f0c7bbafc7569c09ee513f021b36a6417506d74f4917faf2cc573bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "99868844bcaef072fb8a0204e3382e64d45c9cfddc4cba0bb5989b588be137b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ac4c9af18862638506af6c823b8c34db61c1d45eaa6487a453b391b33fd0d1d"
    sha256 cellar: :any_skip_relocation, catalina:       "77b81070b1211a9e2da35b43b000fecebb2a0162a7c879c6bad33bbed422a8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724607e72227702ecaaf926ce9de15d7c8cab3f71c6afcdbe6996dcdfda45121"
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
