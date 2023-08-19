class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.11.tar.gz"
  sha256 "cb2a746505827d3225abdb1c8d508950aa3d769abb0cda59065b1628608efb2e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73a996f9b20ba5ea24a20a75810d46dcae7b088894386a44213557af43b24630"
    sha256 cellar: :any,                 arm64_monterey: "5dd56927bfe50a43238e7e54eb3a980b3ab1ae7e0d9cd473e774257f7e8615cf"
    sha256 cellar: :any,                 arm64_big_sur:  "be7a7cad622a1b3b960ac45d7cfa4730f91ddd93e4ad5f40946ad1cba6e48c91"
    sha256 cellar: :any,                 ventura:        "903d0db68287d54419a469c695ea64f88a2ae9b30566f50d764e59e27038edc9"
    sha256 cellar: :any,                 monterey:       "547a40c18e3f31195e701484b6e14940bf66c6d8cd4138aa0ff3b27a7953c24e"
    sha256 cellar: :any,                 big_sur:        "52ef8103d6dd2e6cdeea622be473e6e7da4d503f7c4c1c0eabb9eb234cd878ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28fd5533958bb66264a53cd9d9ebe4db3ddc944fc7847004518d0f7a5f040692"
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
