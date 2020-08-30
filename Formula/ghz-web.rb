class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.59.0.tar.gz"
  sha256 "132b6d3c6716022f0dfe67e6fbf1cf0311e90b2ab9074b768860a3b9421c8054"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "237c0622f60aeb3613bcb4e7d31485246b2d9b4f08011cc40bc63ecc04f33e71" => :catalina
    sha256 "85b283aae1b112e0f2e8299178cd03bdf45e30cfbbb4caf7c5db9136b29fca9e" => :mojave
    sha256 "38ffadca6935699da755ca16720f32e3535f11fff994bc6f9a73e8b69bd69458" => :high_sierra
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
    assert_match /200 OK/m, shell_output(cmd)
  end
end
