class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.6.tar.gz"
  sha256 "1ef09d971b6de1a6317c109980d6fb5a9c19b39efef2506d6b76869644b3dafa"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1c9d9e0d5124d7a587d67c7f973a0a0e6c3c60a506ff363ac161f3e92299e91"
    sha256 cellar: :any,                 arm64_big_sur:  "277c8d35f55dd5b929f3aa2d5ee6bf53192534491086130d5ec6a32f64655ffe"
    sha256 cellar: :any,                 monterey:       "50970aa781cab68db42bf8ad668476eee794e243a9a7c0ecbed3018176fbad29"
    sha256 cellar: :any,                 big_sur:        "cf806f3552a5d05f5785b749261a318e3612f77920f8e06ffc38f4f5e25d58ce"
    sha256 cellar: :any,                 catalina:       "2bd13c23c55f39d868500118b004e1a19e93da8334106a504a3bb9548b35181b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f91757a3e8257849cc984d8f569e6fc709a04d8d6af0dadd2b5a8ed395ae2d9"
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
