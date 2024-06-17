class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "e16271040935c55d04ac3e2432a5b1613b08c524110729c27fb7735e767cdff9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "837b85ef2989afe8dc3c80fc768236eec50152f01ca46900009de40d8b4527b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b065f80ab783f95e2d528b65eeb05c00cd12d70f1d95f96366fa9484b71f771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5baed4184fde0e28de6f138ac503bed51b8c2360447f3a111ee3d7a50fe5cc88"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a34f6808553d0d40c5ff28178eb03e309c55fd1c31468b6d58ff61db27ac16c"
    sha256 cellar: :any_skip_relocation, ventura:        "3c2a0eb7e59838e558d902f73f3dde7117c1faff89e9dcd911b5a045d60844dc"
    sha256 cellar: :any_skip_relocation, monterey:       "ebdcdd0e38e348ff9ba0dce5af0f8466e787d7416d500a9e9761db4c94ba731d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157f476e5aec6e0e776a06725a1f99bce2344d7bd116751ae20e8d6527f7e1bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
