class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.2.1.tar.gz"
  sha256 "46577afcd255f9c4f193f2408c418e0ca5a66db9c9b4e553058fd4bef28631c1"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "dc3d51a7ebf6c2d1efe50d6cac6b756d5cb46fa63765220099b258cf2ffda7bf" => :sierra
    sha256 "f57134cf51f57e4c801adbaa3b54a21a58faa61e311ee9bf2923456b709e9795" => :el_capitan
    sha256 "87bcd3934b1a4178b611185ba262025b64b44cde1fe7871695059b532456221d" => :yosemite
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
