class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.4.tar.gz"
  sha256 "58098c2e3dce1f652555f269e1544ad4b9bc9bf0aac926c0bef8bf0febaa6fb2"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "021d1e27f3d79c3900ac617dfc80ff5bde1b72599fc3cebc6357f958a9053300" => :sierra
    sha256 "ffef92c5c6a5d9c648b6e3eff43930b27578b2b4be6af05a0f20af5aa17027bf" => :el_capitan
    sha256 "da6eab3c8251643b22086aa7924d5167dad38ab530808493b57ae8980c96f999" => :yosemite
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
