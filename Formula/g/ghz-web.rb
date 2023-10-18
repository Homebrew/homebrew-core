class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.117.0.tar.gz"
  sha256 "33014936ee67f8f139e89e342756d8415880b65c6bb6acb9fbf97132745a1528"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbb6db18d9b8446b59da158d329458f79cae68a5efde4abcc6ebad22cbf71e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fb5f73011676dedd16c117da5489c4601bd9a10f3d686121f851de582eb1d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d7d5ff5fefbb11464876bf6a032cd48eb2ebd67a863896f161605e981b9472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f763ec11a9044333f3a0e01f3930b61376a15d0489cc02dbcfcf6e76bf928449"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a01fd8236b61d336b462906edf55fa138440bc1dff5b74818e6e2aa3e9f8e4"
    sha256 cellar: :any_skip_relocation, ventura:        "f596d94dd82c2acd8dd41a68e049a7b9bf1403d053fb63dc0bfe27d8258d61da"
    sha256 cellar: :any_skip_relocation, monterey:       "a6aec1ae6a60a2e6f8ab4119e0dddcb5654b6ce66c0fae717975b2bd71fa2e78"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfbdcf04415099cf3a26db7e155089debc508f4cfaabea2a2d978553ea37d2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef80789a23ab266fd6feac2223692d77df555d730f5132d1e002bb3e83a7333"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/ghz-web/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
