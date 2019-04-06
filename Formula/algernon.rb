class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag      => "1.12.4",
      :revision => "fd4412ebb5a233b34073a9cebebf131ab7ee6433"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2aae4725141626284bc95b742251b54cc8f67f7c1292842d49fe92e3fab391f4" => :mojave
    sha256 "48367119d506b4fdaf6de83f4f85fa94c613c72707f380235b5400d9f2c87889" => :high_sierra
    sha256 "f2fc1ab9aead13f7c8c74e576a99f691b3e8188b6c6f25de49afa3be68db5a5c" => :sierra
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
