class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.1.tar.gz"
  sha256 "e1c6fbaeb9e4fe82433e51bb9b074576577c7ca6071f8c9317f00107b8570704"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee58cfabc7869cd8b954727caa07af5b20bdcf704696ade0dfd9f55b6c5f7c2d" => :sierra
    sha256 "73aebc10f6bf8bd3a2e310738d27844147fd34ed7b37a6477315f2a357a1f1ca" => :el_capitan
    sha256 "f2c4b6df5818a294463fa887777ca1b4ce8a1a4995bdebaa65863d75948dd642" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
