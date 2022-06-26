class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.7.tar.gz"
  sha256 "4e5733dae31c3a81156af63ca9aa3a6b9b736547f21f23c3ab2f8e3f1ecc16c0"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e996de4c67cdc0c7e96f1225b3e0d55bf4d51573481aad1152ccd4a21f396154"
    sha256 cellar: :any,                 arm64_big_sur:  "abea894ededb62320079c76476f3b64185d4a77afbdbb06c190ff5c7fa756477"
    sha256 cellar: :any,                 monterey:       "a17463b6b5081d11abbd1e76187546def85496a7faabd6ae57b725dfd5b57b6d"
    sha256 cellar: :any,                 big_sur:        "adb800900903650cf7e9aeb7641fab5fd5ecac00d1b9c1e281a736946585ad6c"
    sha256 cellar: :any,                 catalina:       "869af2bf8f690fe4e1b4381c8f0c7d1c136bfc0b1f35a554855b594021dc4cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d51bf073951c5f33e86a09fc3a7a6bb9aa2bbac04bdaa9bb4a75e6ad54fdaa"
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
