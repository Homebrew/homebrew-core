class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.12.tar.gz"
  sha256 "6eec6d46d634ed49620a0c361bc5d6b37eee0d1b11374ee7c555dc2853d04eb7"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d63a0f68561eea0459f97c9ab35d8ba87ee925c5775c8cbd27bd1a6870aeda5e" => :sierra
    sha256 "50e3feb1aeb698702bef02afad88e49a9d1e9aa1e14451a17dd90b15080049f9" => :el_capitan
    sha256 "a08c292b58f9cf56813afed9c584e3f415b6bc9435ece34dfc47a6f4172e3d0f" => :yosemite
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
