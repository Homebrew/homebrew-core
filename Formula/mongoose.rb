class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.2.tar.gz"
  sha256 "8c5024a4e5b5a0c7fdae3c24ebc68e2b3ccfaba08cf25c2e76fc7f14f92fd4a5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "93d2adfd1d2316c0e6273684448fc25c4a97bd79a7e029595835904cb4f0c11c"
    sha256 cellar: :any, big_sur:       "3db2441ef347bea923f2f1a10a0741b4099e6fe0efd77ba965b4221b962a9158"
    sha256 cellar: :any, catalina:      "0598f7de19af511a4c5ff070e1d3e26b3b9068e985c3c60dbe97f54cd8b56f9b"
    sha256 cellar: :any, mojave:        "dc4899fd032e6e1c2c128df7e2ce21d3fdfe90ea93bb40aaeed88cd9ffe329e6"
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/http-server" do
      system "make", "mongoose_mac", "PROG=mongoose_mac"
      bin.install "mongoose_mac" => "mongoose"
    end

    on_macos do
      system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    end
    on_linux do
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
    end
    lib.install shared_library("libmongoose")
    include.install "mongoose.h"
    pkgshare.install "examples"
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
