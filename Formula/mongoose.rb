class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.8.tar.gz"
  sha256 "4d8599aea860b656ec85ee916d6fde318c93bf1ee3eff14ac925907912ce1eaf"

  bottle do
    cellar :any
    sha256 "2a506a291c7dc7c033d4da713ef9a6a4659945095c197de39c5bb8b8865804a1" => :sierra
    sha256 "d29b82feb91359983d2438d36deb6a6d3ba66281ba44839066db8d9fe3790a33" => :el_capitan
    sha256 "658b922190e6ab7c3de9ca6e00bd13c3d68bcd1581c3a1cb3bc2f9a46a03e9f1" => :yosemite
  end

  depends_on "openssl" => :recommended

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/blob/master/docs/Usage.md
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<-EOS.undent
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
