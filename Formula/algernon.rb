class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag => "1.11.0",
      :revision => "5b6969fea95b3acd476bd96ff1b5f38cc09a7b8c"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1f068015c77e1e927f8706375c0ad7ad611648b738e1435d932b809987177e5" => :mojave
    sha256 "fdc8f4c140ae81fab0c3440dca7027ba315a2e7fcec11a72aa46c2ba3c58f8d0" => :high_sierra
    sha256 "2f93b502e7c5ca3d9861c1571dc3d33e4c1f5fe0d75ca52a123121f96181994c" => :sierra
    sha256 "2a1e917824d379406288e08b94841bd53315b9200773e308deff095b84553203" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/algernon").install buildpath.children
    cd "src/github.com/xyproto/algernon" do
      system "go", "build", "-o", "algernon"

      bin.install "desktop/mdview"
      bin.install "algernon"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                                "--addr", ":45678"
      end
      sleep 20
      output = shell_output("curl -sIm3 -o- http://localhost:45678")
      assert_match /200 OK.*Server: Algernon/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
