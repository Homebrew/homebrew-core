class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.3.7.tar.gz"
  sha256 "a408f4d751286cc0ec8b59e1e5903e69f0503c5e4a3781d75293177365bdf969"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab8d42ba1c05939f3d28fc05813150af90dcd6db793d9673a2196fa74c833e4" => :high_sierra
    sha256 "0e293038c3999a34c135fc762ae662f3cfd9c4d0fa3706e09d243b71ab075283" => :sierra
    sha256 "ca58b916a530eae4c2ad964699cf740134887c3b3e8aad6b6e33600fe065d11a" => :el_capitan
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
