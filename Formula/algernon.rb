class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.4.3.tar.gz"
  sha256 "cf67a0938153e8a15743f46c3164944c2f3f2ad6d3b45b862c26945c9f20cd49"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42651ae0197dd14d82a5ec1e50416c0575028139d067f5b2cd38dda99b310752" => :sierra
    sha256 "8b95001602a0ef83151445ae00488a3e69ab4f2d0abaaf2ec4fd23420b00fa58" => :el_capitan
    sha256 "2ee0fd1db921f44d1d2bada985064b8b969e338ea1f52a25b50c9ab291768f92" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GLIDE_HOME"] = buildpath/"glide_home"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/algernon").install buildpath.children
    cd "src/github.com/xyproto/algernon" do
      system "glide", "install"
      system "go", "build", "-o", "algernon"

      bin.install "desktop/mdview"
      bin.install "algernon"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "my.db",
                                "--addr", ":45678"
      end
      sleep(1)
      output = shell_output("curl -sIm3 -o- http://localhost:45678")
      assert_match /200 OK.*Server: Algernon/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
