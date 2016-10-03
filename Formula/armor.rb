class Armor < Formula
  desc "Simple HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.2.tar.gz"
  sha256 "b9106fd828c34f2dce89d7edee0cb3f60788471ba284cbc0fe381990652d463f"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4e5d624c2acd67e78e73bb80e82d27e87f0a997c7c729e47e2aab8927197e5c" => :sierra
    sha256 "b487173f0049d8698d3797d2582d8ff32fa29611290bb175f1e6413732bdeaa1" => :el_capitan
    sha256 "93e07f9e9ca11fabc7e9b52eaa17703652fea0f980d5af14b2b29fe9c0d7db54" => :yosemite
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
