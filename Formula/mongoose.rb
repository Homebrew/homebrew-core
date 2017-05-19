class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.8.tar.gz"
  sha256 "4d8599aea860b656ec85ee916d6fde318c93bf1ee3eff14ac925907912ce1eaf"

  bottle do
    cellar :any
    sha256 "6a3df8d1cb63d469e65fbf63de3f1c5b67b64cab24c5880f1a7c514a87ca0489" => :sierra
    sha256 "4fab01e485b8c62687c8894815225ec60a7b2b057d11cafaa7c1a4b8027968ae" => :el_capitan
    sha256 "221024243b628f9749d489d99feef622effca3fbcb07de66271363b38ac7be26" => :yosemite
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
