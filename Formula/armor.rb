class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.3.tar.gz"
  sha256 "bb90165a70b5ee2e5731b0d626d6cd7abcf8d1bd4e663e67696465dfe217fb42"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2267210faf6149fc85fc40659862d26c5e68cb28cb206a8447575237b797870" => :sierra
    sha256 "235767c93510ee17d61c110ad84afd49e9b2c6441cbe0b4802bdf3956fc6f44c" => :el_capitan
    sha256 "2c43df2b2ed545c3386b5155a49a98b045820019595f7f67d9b6ac2bb1def3f2" => :yosemite
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
