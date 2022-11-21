class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.8.tar.gz"
  sha256 "55073dcd427ab9475731ad855e417884f4fbfb24b7d5694f6cabadbee1329f16"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f8081c830980b8671bb9055574cb20b4e57b09c8447dbb157e86366a9d359ed2"
    sha256 cellar: :any,                 arm64_monterey: "7998ae2f5baf6f285f64228eb08ceea45ebb1e848a0bc0050a05b670f0d6e486"
    sha256 cellar: :any,                 arm64_big_sur:  "ee3b2e1a77bcac51e1eb227b6b7cbcd06281090a91b477d8593a98800b6d30ee"
    sha256 cellar: :any,                 ventura:        "df7a7b6ca96bea712b30c8aad4fda4c2733d8da86976b7133ce89d283f14591f"
    sha256 cellar: :any,                 monterey:       "9270e8f543e74f31a551a56bec241ba3ca32f4fa4e51066453d65f564631552e"
    sha256 cellar: :any,                 big_sur:        "7a13be2a2f240e9b61d453d6e8e83561778a5d99501a86a62071b0be8dd4685a"
    sha256 cellar: :any,                 catalina:       "dd3af2e217dc3b2ff93e2154531503e0b594694e2b94a608473151907544488d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc4276410eb8f29fac51ffa51a9e1c7c664b45e0742fd51f21bc82568fcc9b59"
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
