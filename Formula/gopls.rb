class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.5.tar.gz"
  sha256 "a1ef72e036a70193b39dcae86364b6ac7c85b55d2f4aeec1ee7eecbc560fa2bb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "161d6d2a55f52fbff6beb547649ca659d0faeb0274f21384b219712c407871bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "640b2abf7bb34c3b7b233def57801e82b03e0eb2ccd1be47e58562dce5f23720"
    sha256 cellar: :any_skip_relocation, catalina:      "c23255983fc3f6472105b7e1fc3d589d1c97fb64b3a3a19d2d922f7359b3dbde"
    sha256 cellar: :any_skip_relocation, mojave:        "b5db2727170427b5f77ebd44ff6c2832c06c9a043e80542329bcfb6985b200e2"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
