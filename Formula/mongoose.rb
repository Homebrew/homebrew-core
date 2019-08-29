class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.15.tar.gz"
  sha256 "ed9b44690f9660d25562e45472d486c086bcc916bf49f39f22e0a90444d44454"
  revision 1

  bottle do
    cellar :any
    sha256 "3353e8ff76078ad2193c96d271df4ce1da7448bcf08c6ee1ebecc7e69a19cfe6" => :mojave
    sha256 "1864f6f2028dcc842334c51a1585fbfb49557ef76b1f52ba7bc8e3a9183cf481" => :high_sierra
    sha256 "2df8b1fd42b06fab2579ba49bb82722a4cbbaf982b26bdbda428eca12ea26d1d" => :sierra
  end

  depends_on "openssl@1.1"

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
