class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.112.0.tar.gz"
  sha256 "05bde7d734899c9dcaffb5a5e618bc41e7b294a7197e67d7854429dd886970f3"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a10e79d83180861a064c9e45bf09c2a72adcbe16a98bc00238b9fab40b1eaff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd8f8babd3e7340365be42964bd5550f72d607c4cc4d5903bb00e1e2dc0f811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a99607de8402ff9437fc35d6e8013e6e601a1ac9dbc798fc11e8a796960b7fc"
    sha256 cellar: :any_skip_relocation, ventura:        "fb66277ec0ba7fe7c8efd039db96c54a77d300e98847c99e6b939e0a5b6e7536"
    sha256 cellar: :any_skip_relocation, monterey:       "665d87f26c3b201d44f56a610c73f3fc66c3b0246325cdbbfe2cf9daf2b6aace"
    sha256 cellar: :any_skip_relocation, big_sur:        "844495bae259884d9fbc6a5c7e81931bc6d3668e2c36e1bb873a55433cc6d7bf"
    sha256 cellar: :any_skip_relocation, catalina:       "a8e28872d198191065312f628f320b2e9877aee239686deb63d62dcd6f5924f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fd3c7e6348176ea6d2d454ef99b3408b9d918bbbd2a9690bea3bb26bba76f7"
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
