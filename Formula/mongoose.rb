class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.11.tar.gz"
  sha256 "74ee598bb0eba87780becb56586e4342d1b9a85282c53a11cb5ef87d2b66256b"

  bottle do
    cellar :any
    sha256 "6fa1acdf5c7e46de955ce5e93009282334656aed8b0688696599cad321090031" => :high_sierra
    sha256 "50d13fe2fdbc27d16f5ad848051367ea53bb3b023c6ae7264ae2ac948b3a0e0d" => :sierra
    sha256 "4b0a42acac7459db6acd68251ae0f30988e24d15123fde3b392509aaa47825ec" => :el_capitan
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
    (testpath/"hello.html").write <<~EOS
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
