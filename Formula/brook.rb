class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20221212.tar.gz"
  sha256 "bc0bf33d65a31fd85a2eb50ea9dcfffa0fb66f0213e5d6eb94a69fcdd8a6007d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "785162e87c02d99a4badfadca1de0ecd235f7864d2c8887166b12d3b95daa69e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6408ffb549f9adc493ce3364dbdece1439f7a0b62d58f959f6f279fe7a3cdbf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc14ee60421131a30b3de7a8e0f79dc2a8942e5ef251b95b53b39a3be2509f2"
    sha256 cellar: :any_skip_relocation, monterey:       "e560e4f41415f2b20f8d2e773465c47eaf26472478a2cbf89c948f57c2e3904d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5928388c4c9fdee31ffb58db5aed486484735c2f0991e15b2af765407b2c6c53"
    sha256 cellar: :any_skip_relocation, catalina:       "39194d775f5bb9ae40fe4571c99202d7b729668e27dfa2dafeadcbfbc5b91444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6262104353f3ce66f85e8820e306b0f5d45791f500b0523418d14acad0ff12f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789&username="
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
    assert_equal "", query["username"]
  end
end
