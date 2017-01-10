class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.3.tar.gz"
  sha256 "46577afcd255f9c4f193f2408c418e0ca5a66db9c9b4e553058fd4bef28631c1"
  sha256 "a5a5976ce75c58b0a1ec10ee8185457fa590bc4e7473f061053bba85474208cc"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "c01c2947279e6bbc29eaca07a022cb3276d82d6f7ff6dfa9f1057e12ed764c91" => :sierra
    sha256 "ac0d53e57be4a00dd8ade3c9ea384730d00ba4f540b5db64d697692a66935446" => :el_capitan
    sha256 "0f6c5ee39192dc9f48f735fd8d68656cc50fda5234758490f5f53d41a85469cd" => :yosemite
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
