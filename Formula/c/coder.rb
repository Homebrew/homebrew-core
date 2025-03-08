class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "4618c01402e2b5d3f1947f927610fe6fffa7ae0a31ca66de7d617dba097c1837"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d994d246f62c61c38b12285823f6f9d37efd6f068638576c829e0470919b6837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ac8d8d2647a14b60d5136c7032b6b7473b244fa65d026e7493cd57404f12704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "249facc422ad951544702adcb12439ab6b7aebc425dd43e13c0637320f32b446"
    sha256 cellar: :any_skip_relocation, sonoma:        "62edf7443ff5f6ebe3202b94ba0397405d2db298570cf5ccbb4419eaa8c9c3ab"
    sha256 cellar: :any_skip_relocation, ventura:       "4ea7076e17400bbdd6b179be00589a162782a1ae9069e3dd20ca0a03eaca9aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a176e77583a83714873c2d233e2eb7aa1ec6315f7727278b001ce5cc5f5b931"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
