class Blucli < Formula
  desc "Command-line tool for BluOS players"
  homepage "https://blucli.sh"
  url "https://github.com/steipete/blucli/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "0822295d0e93cead66ac6e0d89606793fa9664bcc9898f1eae19450308d74f11"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"blu", ldflags: "-s -w -X main.version=v#{version}"), "./cmd/blu"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/blu version")
    assert_match "no devices", shell_output("#{bin}/blu devices")
  end
end
