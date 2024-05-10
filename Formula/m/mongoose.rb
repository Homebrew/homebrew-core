class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.13.tar.gz"
  sha256 "5c9dc8d1d1762ef483b6d2fbf5234e421ca944b722225bb533d2d0507b118a0f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9dc15665c6045def9510d6f554994a4c933ed9a6031109d54a38672ba65e3e6"
    sha256 cellar: :any,                 arm64_ventura:  "a8d6e7fc859aa4bfe2f8b6cd97e9480a6f0f55aaa0a871677693f6b01b9d0aae"
    sha256 cellar: :any,                 arm64_monterey: "3684166873863e2042938215be5c0c352f42d12d1327c392bef9bc472e2d6a50"
    sha256 cellar: :any,                 sonoma:         "9342e3597f35d6474dff21d0b2402da7dc74bb104512f6f89492723c401608fc"
    sha256 cellar: :any,                 ventura:        "372366ea632b1594d8876705860208c40554629ba5409cf9e3cb5f2682c08a3e"
    sha256 cellar: :any,                 monterey:       "b708e50a24bca539b9f56477e05b22ec58ae5207f84e8517eb1f5875a8804bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3109cd6688f7757fc4a1542d422eb0a0a23481d73d92ffef5f69f04480cfc4"
  end

  depends_on "openssl@3"

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
