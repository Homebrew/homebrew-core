class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.8.tar.gz"
  sha256 "55073dcd427ab9475731ad855e417884f4fbfb24b7d5694f6cabadbee1329f16"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "992bf212139719563761c18ea86cc61339e6430ea5fdcf761f060e48cf638299"
    sha256 cellar: :any,                 arm64_big_sur:  "c092c739a7b3b414f1075c44feb15eb586a2bdd6016557a2bd64b48c611bad20"
    sha256 cellar: :any,                 monterey:       "5c0645061675cfc9456f526440970a56b0da2effb92aa1f25f2027269256226f"
    sha256 cellar: :any,                 big_sur:        "8af167d5c4661a8718e48e4c14dcecd9c0b6b18b154667f76e6ad0bb12ae4e17"
    sha256 cellar: :any,                 catalina:       "8b5423fb4baa91153431a4fcd01623004444c4e202aa51a7c0b9922213cb53f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df63b1647338abd665c74e5d73ddf56bd8304b199aa9963ceac77b63f1bd764c"
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
