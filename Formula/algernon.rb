class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag      => "1.12.5",
      :revision => "206912d922bb8ab96e23708d1cf222d572741ebe"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa5efc4b459178262db04e6cf12f24ebdc7540eae749e8b86b4d01e4b74a856b" => :mojave
    sha256 "01ffdc4770c149a2be689b33235eff7838352ad20d11f1ff1c2c9c0a40f3fc24" => :high_sierra
    sha256 "abeffa6872984c9c33550a267379c79ae2e4fe3f1370fa67391c6ca3040bf3e4" => :sierra
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
