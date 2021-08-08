class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.99.0.tar.gz"
  sha256 "474c84f9d8cf7da5db177f12b0f0f242b500ff42363323bed39f73b4a318bcc3"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95344a07ed48448946db436f7b3c231edc6724ba9a26431a3cc5f03e1ac30be2"
    sha256 cellar: :any_skip_relocation, big_sur:       "f32c5695c0457b95e86bca9d4265f481b55211ebe3502d0e9948430aaa1f07d5"
    sha256 cellar: :any_skip_relocation, catalina:      "84f46227bb34346420448acb9675d6fad145322f7d6d85b2d7805e200fef30de"
    sha256 cellar: :any_skip_relocation, mojave:        "b219bdcf57302021f4c3d8d726ac26252ae6879689c4e7bd8c192db47044f8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c0cfce8ac127c3c2342ff17671b102d138be1de7fec159652b01989b26f558"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
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
