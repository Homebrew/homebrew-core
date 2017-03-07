class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.8.tar.gz"
  sha256 "a9de72d2a88f7e3790ef1f6410923aaaa596756af141085854ee26e65a63233d"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d4c3e3041bf225097b6cc8de8fd2502e967214d4c91ed1d4103c8c95ff1750d" => :sierra
    sha256 "6fa112c60b91352852abdc97af4f162502eb0db8f31f0f6b8db698b38dd4871c" => :el_capitan
    sha256 "9840e0a9f42aba0469dbf3a7eb2fb48c9446eb320112302b8f6aaae5c2f034dc" => :yosemite
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
