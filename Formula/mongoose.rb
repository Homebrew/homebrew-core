class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.16.tar.gz"
  sha256 "1f20f2781862560ddf3203dfb0e6fcf248a68bf92aefbeafb9d2a629c4767c02"

  bottle do
    cellar :any
    sha256 "f9cf735cf2fe8035d9f9395484dc882e4d3cc7c14ee4acd6d95f0f4bdef5e0ed" => :catalina
    sha256 "954e9e0e047a954e67757ccb281ee8d5ef8b318a299337c4d9a63bb033ddc2dc" => :mojave
    sha256 "b1802f5b9c7417ce3e90d9eae088591c10ecf75e9c17d70a57192a640b7d189a" => :high_sierra
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
