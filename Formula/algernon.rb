class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.2.1.tar.gz"
  sha256 "46577afcd255f9c4f193f2408c418e0ca5a66db9c9b4e553058fd4bef28631c1"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "32f30f262a19cb122d1817f11dcdb9485e36f9fbc05e823e391e3ee59260d9a6" => :sierra
    sha256 "46f66205f6de057ffc28e1739f50fe2a18029bccdcae8aa96930641d772e8cbd" => :el_capitan
    sha256 "083a19038dc8025ddc0228211600e5dd5331a81e014e76976ae9282b4286d2ff" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "readline"

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
