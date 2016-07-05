class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.4.tar.gz"
  sha256 "4691ade3ca645e568e0f6049953ac13cabcb289a734fb0f245a6ddce12f97d41"

  bottle do
    cellar :any
    revision 2
    sha256 "5bf038e627db9453b463a081a58b7e289b112cdf8965209547e40eec047c258a" => :el_capitan
    sha256 "158f24303e018ec3f9ee05d3ffe10a2399b700cfdf869e9fe2970f68105b1fe5" => :yosemite
    sha256 "53cbd378f59876d7922ba743c99dedc305707c13caeea0339667bf5006080b24" => :mavericks
    sha256 "e9ee23cf028f5be715fbae963cf661dffc9850b71039c90f2aae70e07c410fda" => :mountain_lion
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
