class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.11.tar.gz"
  sha256 "74ee598bb0eba87780becb56586e4342d1b9a85282c53a11cb5ef87d2b66256b"

  bottle do
    cellar :any
    sha256 "569e2ff5b7d5864e3133ac6b5d941f5681006d06b8506b4fee1ac1cfc514ff74" => :high_sierra
    sha256 "12e2cdc336a00a9798bd2bc5e278a39ac30fc93055490e3faf069aff1690a7d8" => :sierra
    sha256 "788bd2c11b0edf968e786cb4869b8ca383df694f868c81cc269ca2f3eb7fc5f7" => :el_capitan
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
