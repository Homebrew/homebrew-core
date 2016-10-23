class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.5.tar.gz"
  sha256 "4967c7867cff514aa1d3f4ab90cd348e25c473254070dd968273480e6717a039"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02111124b02506eda6a71ecee016ec7c2387fe8d552e1d36b85d275e65cc1b5f" => :sierra
    sha256 "66ed1d53ab7fb979e5349205711b0082cf1db97d8b1286881766f63ad02f93ef" => :el_capitan
    sha256 "d35b8ae62887d095c229ef1585e937810803c7f45a4a042e2b7d2171e1e259f4" => :yosemite
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
