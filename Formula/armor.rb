class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.0.tar.gz"
  sha256 "5827d96bab4db88f9c9f3636014ebcb51f9e29677f5587459c972084ed73366e"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "024ee7b30d9f73b7eef35f54e949d45b480db324ccdecb150987a2702f001d39" => :high_sierra
    sha256 "5b1b21b9707f13722054aebc5427dfae316a1cdee4a0eecb5e5a948eb667d5f3" => :sierra
    sha256 "919efcc06f0b91d9c113593bb0082f47e3871f214e9138e8812b036603520d84" => :el_capitan
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
