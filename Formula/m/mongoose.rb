class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.12.tar.gz"
  sha256 "91e719e164816b349be3cb71293927f3f6abbe3fb02187e2d9b5e56f542c2063"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6845d6b809b54bd35f18b477cbbc47010cd2e76e965f1244a15b91c74ada8625"
    sha256 cellar: :any,                 arm64_ventura:  "e070626cd88c0444afb90250f6c30c8cc15a9d66bc6616022b9851c719817866"
    sha256 cellar: :any,                 arm64_monterey: "4e10f8e4e8c23c25a67d18a7d3e4af20a6f3d8b82ecd6e31b646b3d5ebdf5006"
    sha256 cellar: :any,                 sonoma:         "8d4b68e574d6c0a17756345a2f848e7c74e267c1b9ace2ddb1630f1211488935"
    sha256 cellar: :any,                 ventura:        "b86348df5d274db250bd2ffd668e6677cabbc7e1eb39edbc68ef32a1a8a0a322"
    sha256 cellar: :any,                 monterey:       "2a8361fbb6222f2e24943b36fdb9a6426416e24960be2100ecfac315b15096c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5d90ae0447d386e367008fa03c8e69f56d505819432798e8d55d96be41f1d0"
  end

  depends_on "openssl@3"

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
