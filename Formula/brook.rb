class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220404.tar.gz"
  sha256 "a119adf673df8f61fcaec841e471392cfdd9d307fe52ec9d6b3d9393846a7630"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4742c24be5fa0765b3aa16179793fbfc2bb18bfcfed788434fca4a8815e1d5bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76789baeb8d527f328223cd15d0dfa5557388d3df01c47df9a28b901dbf634f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d8221ceefc98f9f5be210ca26c345b5cfc24cc0e902b0cc9f16fa887dd2f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "e14d0602ea5dd95ca0bec06fbd9ac365422fc38e5930f969e207d743e42b399e"
    sha256 cellar: :any_skip_relocation, catalina:       "84b9bc1480a0e1cc4f1c0bfc1f9eed5882ba0e13ae2f26ba806470db84e29b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1f8677d3ab9d9e973503d50eab5ce4600ac9353da7ba34223e4f077f4f74a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    assert_match "brook://server?address=&insecure=&name=&password=hello&server=1.2.3.4%3A56789&username=", output
  end
end
