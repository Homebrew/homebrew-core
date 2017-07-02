class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.3.3.tar.gz"
  sha256 "9aae852ba96dddcc55d279ae8dbb4de12d5598997b5d5d277de415effce5da8d"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8effae118330cdd077a56ef9fe674f64131bcedbf97947d851ad257305da5712" => :sierra
    sha256 "dbc492ffd65612c33d676b3d61ae68e07d020fee0979f86670bf8d6cc26d28ef" => :el_capitan
    sha256 "d7cda77ba2d16fcc7b5a2f4a322601530aac9d9427bfd4a8c4f140e99a08035b" => :yosemite
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
