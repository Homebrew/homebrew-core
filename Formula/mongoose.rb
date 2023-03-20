class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.9.tar.gz"
  sha256 "147d51637c5ea95a592487fc4bc64f9c2a719a8f519d379636f2a8b83cb8e672"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7029cc380ec28d2833b1f44027532fb8251bfb5dff8951888b8f9c30b297ecf5"
    sha256 cellar: :any,                 arm64_monterey: "3b1d0e208e186dee9208a210f77526490de0e8a2abece1604241ef5b7517f3c2"
    sha256 cellar: :any,                 arm64_big_sur:  "42ce689b33b6e803a9ac5087e76a21c190343f7332a8abd37cf7e6ff421fb4bb"
    sha256 cellar: :any,                 ventura:        "7d6acd71843441cca6f7d17c43e63c2e28ccf88fc5e3d4bb6e0bb04b5f0c8342"
    sha256 cellar: :any,                 monterey:       "71d1229fac95a44ad0427b83f19a4af96e5afe04bdb88512d46aa003a162329a"
    sha256 cellar: :any,                 big_sur:        "67667f049ea0284e7f4353006db2953b0f5b49e95ec0673ff52bd5ea0b0b7008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6146ba2bceb453dc7f21469501518a5f2b4ab505f7e64d834e8b2ba0d19a3c7"
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
