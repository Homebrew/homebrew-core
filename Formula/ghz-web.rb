class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.71.0.tar.gz"
  sha256 "87297207fc8e5c245dc49376383608c9950587463b28da2408f51038fbd67c56"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6bd71c5bd353eefc9d417767a96399fc9f7151987ff0a791def6aca7685a7b1" => :big_sur
    sha256 "fc7b27ba50f95410c7717ed744be8554459b2e623272e42bb6502d8b277b3988" => :catalina
    sha256 "42766bb8cd7d020c754511040f1dcbbbe8361f4e1cbce66e7cb6ddc76a45cea1" => :mojave
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
