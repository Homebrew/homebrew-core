class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.9.tar.gz"
  sha256 "ced2bdec255ed8d384d06833df8d694520fc057ac6e09bd23560b9bc355230ed"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0c1d9c55d24b45e7b980c5d58cf527a63ca166f2faf9c4c4adc3d627eb52c3c" => :sierra
    sha256 "5ab24590d703b27614de2c0f4916c2596d73a7331907370580c99f15ee5626f3" => :el_capitan
    sha256 "f55745a636ece4c3e2a8c9324d2d9e3215042376016879089026ca6bfcd4fd5e" => :yosemite
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
