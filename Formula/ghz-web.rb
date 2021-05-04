class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.95.0.tar.gz"
  sha256 "c41af7b43027d2af3a2aeb0b28353f59995cf295ae013ae15ad952590b9d265a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38c0a6825d50a8a6aa61d1402fa94d0b2f4b446c865c4df8e98b5ee4dbddbeb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "20d15b3837e09aec7395a2aeb719265bcde0a22a18a472275f8dc35902128598"
    sha256 cellar: :any_skip_relocation, catalina:      "87bedcabc0ae7c96ba62208e6ea8ca3aa7bb982b05a4dac6a5258dc95f6203f6"
    sha256 cellar: :any_skip_relocation, mojave:        "90fac8b608f1705748e01667a1be457c9f8025114ad5b83e2a859e26b6ef0747"
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
