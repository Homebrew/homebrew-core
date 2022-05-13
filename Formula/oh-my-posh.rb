class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.82.1.tar.gz"
  sha256 "48d66db46b6afcac02458f60494dc7b131607e8023f0da4e05b2d9b39f5afd59"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd53f045c56bd9a52e2ce0a7672c320c882e54aab1149b3683e51c2692760bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3e3b4a787adbb4c15e580990eb55ad0c10c5bd85b3fecb066675e2c62e879e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f27d988447da206f17d1bb58a1a2577ad3e4e7c9bc68cab2130b964ce31207"
    sha256 cellar: :any_skip_relocation, big_sur:        "1873633015b35e3ca67b5b4724d0d4b0f521876d23ec75a92a67509788d32be7"
    sha256 cellar: :any_skip_relocation, catalina:       "549a6d5170d09d3b7b659edd5bf1ae822953195cf5fe33ed79ababfaef56c2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00e8f8394da5656281a609257571b0d1e16b1e8e8a149633a549bc7a715fb12a"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
