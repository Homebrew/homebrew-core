class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.8.tar.gz"
  sha256 "55073dcd427ab9475731ad855e417884f4fbfb24b7d5694f6cabadbee1329f16"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99d54b7eb04da840546b5f6cd75dd639f75511cfae270dac63ad969eeb564e3f"
    sha256 cellar: :any,                 arm64_big_sur:  "6b13a569ff067da50f3a34fa551d3f7d1037f3234aeac6a4f491f88b46d4c339"
    sha256 cellar: :any,                 monterey:       "5309253949c1309a1a05ae2ed7bfdad0a89e6ea6198e63c1ca537b650cae76c8"
    sha256 cellar: :any,                 big_sur:        "3a83ba20f3893bc9d12ec35e0fd630adc6175e76b7646b787b5796843229e574"
    sha256 cellar: :any,                 catalina:       "a44483088dace829578d9fbc0bd459c2137b67d9fe940d5ab03a6329e1dc5a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22f7511e5a7d3f12789d62ee57477ea34f3cc97948a07b080b1a1353f0e58c0"
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

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib" if OS.mac?
    if OS.linux?
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
