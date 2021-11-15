class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.4.tar.gz"
  sha256 "6ecf0534a9a7834455abc410226066ac038d0e43c25eb7cc3a4585f9d767e477"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c005a2ff1a9631ba39b062b1785c8ec9beeb1c7d9aad70d7e569f50114c28b9"
    sha256 cellar: :any,                 arm64_big_sur:  "a9b43175f92e8b23abbd752fd0ed21879d89595caaec340222775da33cac7d5f"
    sha256 cellar: :any,                 monterey:       "e00fee67719e59495dbd7ff71c46636d3ccd636240b5b4155b24a38eecdbf4f8"
    sha256 cellar: :any,                 big_sur:        "f983ab7ccf9331fcb3955ce1a12974345016b95e68e221e206a24b1008efd3a0"
    sha256 cellar: :any,                 catalina:       "633718da5b3cd80405580bdb7e8e1fb49cfcd0750341ea4c3283613a212c1f2d"
    sha256 cellar: :any,                 mojave:         "6af8c2a0736cbf2ea1c69266c6af4bde1f2bc3005e0550f2875ec3acd7b155d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d03f8869ca3d67dc687cda9e61bfff91aaa9c82f5437dcb0191e9f062890d453"
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
