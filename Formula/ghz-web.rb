class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.90.0.tar.gz"
  sha256 "fbfd832bd81d4ae5b9bcd90b6a441dcfcd63e6519eda16dcab6282ddb06cbc8f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "635f763cb3e1f7784738a9e00f78d071e338767a3a83d85a018ff28290a45b78" => :big_sur
    sha256 "3bd1c4d33aebbfc83adb9253bf8c3cc063d6c2fbc7838741580797da00f51fc8" => :arm64_big_sur
    sha256 "2f4b7a22ac366aedc26b2ea83706ceabd018f0a3a8f840bcb4c0ae1dce05cd82" => :catalina
    sha256 "4e4d673e23d8178d9c7c0207308038d3fa494f3117941ef2611fb5ef937e225b" => :mojave
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
