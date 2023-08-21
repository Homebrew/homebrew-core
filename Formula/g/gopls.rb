class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.13.2.tar.gz"
  sha256 "fa8a5d38c1e040686fda6018c3456801229d6ed992b6eecfbaba146e1fc772b2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70553eebb2218b4062c6b452eb7a5168e33224eaa396e847c45abb1825fbf5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be814087f6076a7dfe35dd081c0ba4f19f7ea8f0afb02e6ca67e6d6903b379c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e143169671f2de627e2eafb1aeaa01fd2f968b3c4d3f3a099203bb1bfeaa02"
    sha256 cellar: :any_skip_relocation, ventura:        "387c68defd0858cd6a1b10faa3ffe257c07690de0839613d7e28da2371c7cb6c"
    sha256 cellar: :any_skip_relocation, monterey:       "b23844b76ed2804c6d3542b674d4de76d2efc1fc8f15866f34254e888382933d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ee2673f9a1fdb85b7992d2dd8bd06f3dc1b924159eedc87099c11fcfa27265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf94c5f4b6e967c8d4357b82970af8764ce4b6166c2c1039f8cee23beb7549c"
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

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
