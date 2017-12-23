class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.3.4.tar.gz"
  sha256 "84511f9fb563d484668b0a5a4aaadb59c2434dd31a5402c58fc9482c034d32b9"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cadb4707f47b5e6a73345908f8a81631c5c1f69150f33b6a3c8bd46581fe4865" => :high_sierra
    sha256 "b5b3c248387efb9fd215eb9544ff774dcc9081ba2323cf744401c7857833a85a" => :sierra
    sha256 "e8d5ddaa081c6da1a9221dea0d6900de34dd63c5f6092659ab50520106da6920" => :el_capitan
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
