class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.100.0.tar.gz"
  sha256 "59db1c8a167e638e003fc6ba028e0e64aa3c3e4d5a921138b6b1c0bef1b0aa40"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fb863d76bd1ba2ce75f4c3458cac031320567b3615da1902e44286331947980"
    sha256 cellar: :any_skip_relocation, big_sur:       "50f110f346d2917bbf2c75f4a89289d0402ad8c194acb7a31cdaf47404903dcc"
    sha256 cellar: :any_skip_relocation, catalina:      "22b7a6e36ad835bb9d9aa5d7a1b1d8118bd69755591c23f3e07eca936b86a421"
    sha256 cellar: :any_skip_relocation, mojave:        "3325ec9804f4419f546afc2ad9653b7185126ef2c78ca763f0ee04a16f346c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c741364e81c880751060f905ff68c0dec52548f33b0203cb5e15a214630a007"
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
