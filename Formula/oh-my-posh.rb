class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.8.0.tar.gz"
  sha256 "348cb00692cada06ae0d3e11483ae453591be36d3137517c0e240325e6d44aa9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f5604e6e8660e615a622f0c09d1a22036314ddd952fc735bcf5bff9d4b1506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d3c02f28252486ca4f120937ff47f315e1b3783a237e8fa6aa538ae111b9d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1584536fbc276ea52f0703309f8d9273106d2565d3ae9ec4e903bdae96b4230a"
    sha256 cellar: :any_skip_relocation, ventura:        "b733085ab812f5def90f6a675c25ee0353cb2349bad692eaaad92ef5698c93bd"
    sha256 cellar: :any_skip_relocation, monterey:       "7f6997b1aba54465a329288eac767365a1cbf1fca08665a376aec1317771973b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f5d423db503a3ad9dfd1ee2bb8bf6b8e8c95e73a7aac1fc135e92acc39464c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a76b569e2116e924fbab3ddb6b54d399106fb0ff26a5e0ebc11af51a48e8529"
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
