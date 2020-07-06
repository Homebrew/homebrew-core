class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.8.tar.gz"
  sha256 "562d6f1145980d5e4c8eaefc2780801b163d228720599f22165135182018d6bf"
  license "MIT"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19d76d366a23558e40e5dc37cb8be6807afafebc2b85549bd61df488b4b8ace7" => :catalina
    sha256 "2f7d73a7d99ea6ca4d406388ea7475f53ac022ca11f9df7ce5e7ff6bf629a634" => :mojave
    sha256 "fcc2b783a77662cc1831dec57d1895cc078746ecaf4dc618b7df1e165254979d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
