class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.3.4.tar.gz"
  sha256 "84511f9fb563d484668b0a5a4aaadb59c2434dd31a5402c58fc9482c034d32b9"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99098de421235ad7bd858d17b513d1d749e55f95de45aae7b2881a01e0686d15" => :high_sierra
    sha256 "220a596d95078e185c9f8535654d102b7c9de0075949acf1308ba06043176ac4" => :sierra
    sha256 "6b27b59057496d4bf8d652e4d81ec6eb9a5fc21b9bf86cf9744c34754d1f3156" => :el_capitan
    sha256 "f2a826f6dc9ce37a5c9c0a561150a367aa774b4dda75ef925c2de09df5e24f78" => :yosemite
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
