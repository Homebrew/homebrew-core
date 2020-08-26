class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.58.0.tar.gz"
  sha256 "556a220def71ce28a8fc04842f66b5e235c01d26d57655a722838547671aea6c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79b278cea4fdcc1766adf3d906163e0af63ab058e1374689ccc564f88dd67c62" => :catalina
    sha256 "45e3db2a88ca849787daf019cca037452460f785fd1259e51fb27635196717ee" => :mojave
    sha256 "c9deaee43a4682467f6ef2525272af7866f08dba16bcd7a3833f2f6495173d89" => :high_sierra
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
