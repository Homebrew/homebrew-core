class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/0.6.tar.gz"
  sha256 "66edd50945a689abcd07aad5047317dc17cb17ec5e813f63c3520394696a6fcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f62d23d84ae854af037a7821b0cf5e1176492683c0c2ee1587d734732020be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7be6e6c6769e5e9ddf40052e9e2f346f0b99bc6fa463fce8064c6a14e9f3742"
    sha256 cellar: :any_skip_relocation, monterey:       "fbff60f9becb301c4b12108417c121d81d99ffbc22e6c4cb917800d333895c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "3770d11ffc568d1bc4e037c99af6bcfd1cc448e015d7dc5603f1277f4a08b21f"
    sha256 cellar: :any_skip_relocation, catalina:       "3770d11ffc568d1bc4e037c99af6bcfd1cc448e015d7dc5603f1277f4a08b21f"
    sha256 cellar: :any_skip_relocation, mojave:         "3770d11ffc568d1bc4e037c99af6bcfd1cc448e015d7dc5603f1277f4a08b21f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
