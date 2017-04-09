class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.9.tar.gz"
  sha256 "ced2bdec255ed8d384d06833df8d694520fc057ac6e09bd23560b9bc355230ed"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d68eb622d91728677955805b66b79222f08c949e339e027252da1f35aadad400" => :sierra
    sha256 "c3758dbaa2683ff2c61b9c0d6ae6ffce01d975509fd52695e0d97111130b481b" => :el_capitan
    sha256 "4c6de98f1658118b4135369f03d1a214f0cbe6b91f0d0fa4bab8d81c1b095ed5" => :yosemite
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
