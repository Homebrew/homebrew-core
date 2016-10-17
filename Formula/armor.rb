class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.4.tar.gz"
  sha256 "a6d0606fd47b5961844a5d5386362fec675733c2dba7f8da9171e336ba8b6df1"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c58009d0b8f4456a7f8868d37ff3d1ce42bf737eb6aabffae53affbf007e42fe" => :sierra
    sha256 "a09425c110182f1e17fadcdbae7adbe606e88e84e15f47309966758b6ff82a66" => :el_capitan
    sha256 "343cc0ea636a128b42a247909550a842f7827d1640ecdbaacfe5bd21ccc2ef89" => :yosemite
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
