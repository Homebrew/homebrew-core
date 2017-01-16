class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.5.tar.gz"
  sha256 "0283492ab8bc92305418e90a5704fda89c6f83fc75a8ce30659d35ac55696d2a"
  head "https://github.com/labstack/armor.git"

  bottle do
    sha256 "5d05faf503880c1358e550c14f82f946f171ceb3b2e36fe87c7ecea02add36b2" => :sierra
    sha256 "47982967cbd64367307724e0e6d62e68cd4441e9f48a2d53d2e12cfcf2f27fa9" => :el_capitan
    sha256 "bb8eea9801eb1cdb96b5d99a24cab22c3c16955bfddb3fde62584557ab271809" => :yosemite
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
