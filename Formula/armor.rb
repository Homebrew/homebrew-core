class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.2.tar.gz"
  sha256 "c3caaec847e3bf8b0efa75444ca75cb42a3847791a2d05e1846c5c77b49c3fea"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0820a95564db9e7f69c83768e6de99423aa89d3061e63edc63fb502222ddc307" => :sierra
    sha256 "0b227823fa6750f709f53f5bf56cf8d078cea5b80216e3738df2aa549ebde6bd" => :el_capitan
    sha256 "706e8631b5cb789555299b1ffce33be822f4def40716bb8a8120646ad31d0810" => :yosemite
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
