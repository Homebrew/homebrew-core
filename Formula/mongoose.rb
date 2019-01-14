class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.13.tar.gz"
  sha256 "ec7956b8f2845f6c22e19ab38a0c32c9b379087f0038c7db661b34812f225911"

  bottle do
    cellar :any
    sha256 "00e7662046f84e6e48ddecf56f471bd7c2a5acdbcc919ead7c5457a1126617dd" => :mojave
    sha256 "a98aaf1726ab5402dc2ccd1418f71b32f0c4034f4be4dc8f3a93257b7d9113fb" => :high_sierra
    sha256 "4960b6b0cb836bca2c4d5ff925dfbd6d09d8952c239cbc912200d5c509c5cec5" => :sierra
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
