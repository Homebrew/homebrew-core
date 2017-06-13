class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.12.tar.gz"
  sha256 "6eec6d46d634ed49620a0c361bc5d6b37eee0d1b11374ee7c555dc2853d04eb7"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4492bc1f1f338a243cabd8a810478816c32e522a15b066e24d344d74a81b00e6" => :sierra
    sha256 "0c506fc1e3cb261a7b4307aade91c10a88fa74dac7685b127ab4357aa0447f02" => :el_capitan
    sha256 "b9d86b1443ec66dc0a779135c426c71ee270b4c9c5aee1dafdf58c4423d85768" => :yosemite
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
