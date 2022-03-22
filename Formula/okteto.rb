class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.0.0.tar.gz"
  sha256 "f5d9dbb07447a21a8b7b36ed81c165d9367a0bfda5183cb381e609b55448bc98"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4136a7d983f3dce5bf879193834c824f38648d8007f1c2da44e1fc1f6558b806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639bdfcb7362ef2dceeec9750351d9454dadadbc0b592cdd8c46fed8760b72a6"
    sha256 cellar: :any_skip_relocation, monterey:       "381cc35c49bc619dafff132b6e9615be73476e58bcad1b6e2c6852c42ac81cee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45f562c18a72a4caf039412995055c8ff8d03bb90e1ebc1d520baafef83dcb6"
    sha256 cellar: :any_skip_relocation, catalina:       "070e0735e8ea3d1f68b002d933fa4fd68ef147fbd00942903eaf27cfeb44f984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a6fec296302c44dbf9fdb15cb5ebbbdd27c42e227390ab5f4a7d5016d63c87f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
