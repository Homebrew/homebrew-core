class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.15.tar.gz"
  sha256 "ed9b44690f9660d25562e45472d486c086bcc916bf49f39f22e0a90444d44454"

  bottle do
    cellar :any
    sha256 "d26995b756965ae3b9e62dfe7cdef465d3b24a795c4c2a89dcd215c69adbab30" => :mojave
    sha256 "27987f00f07c5515c89aab7c38830ce3b0ea191215e065b1608e1db115ad4904" => :high_sierra
    sha256 "42d51c600cc16d6bceeb0dbd68310cf572b05c2bea83bc1eb42d50e7a3a561e9" => :sierra
  end

  depends_on "openssl"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
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
