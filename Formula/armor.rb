class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.11.tar.gz"
  sha256 "4d6d3876c7582f082215f1f8a6c3209a65108b46322cb82654790ca10773c10a"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b528b340430188abeb6bcd74d4bbf673bff11bf2bf275547b6d8b173601bb24" => :sierra
    sha256 "f078d61a16e295ea204e80e0897460cd0e91ef749da2ebf42fc9044bca6c3f48" => :el_capitan
    sha256 "5274ff11a65d6cc8826758a7d413ccd331c135495d0a772baff817b4e6f77bdf" => :yosemite
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
