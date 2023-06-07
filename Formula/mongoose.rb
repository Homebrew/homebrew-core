class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.10.tar.gz"
  sha256 "7cab3d6984b67fb78fb7f32441468b13d256ea8ecd2f73021cab8295d82d5a63"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7503b5b31e66958cc73cae67358b03686e77fd5bacd3dba940e4d523a6ba4842"
    sha256 cellar: :any,                 arm64_monterey: "379e4cbb87d908ec32fca4887c7d99c40afc5a57b24a04518649ec07757a4809"
    sha256 cellar: :any,                 arm64_big_sur:  "284144b506b8b21495d6867dfac3bbbc64f6a69fb7c939ed122d9a9259f30268"
    sha256 cellar: :any,                 ventura:        "3e189d4bbb2c5d74d0928e593a7924e9d937986cc38c87031a92794cbbe05975"
    sha256 cellar: :any,                 monterey:       "867f2b2483c9fe76aac49f415e97e04540710d2027c223a55348b5a229c74b85"
    sha256 cellar: :any,                 big_sur:        "9843ae80d5907aaec9d1d6bc29cc3af60ee22d9abfa485df15783cdebc6d9e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441dc85445e06958fdef6c2761674bc51d0a10a803fc0bfb90f542f8e93e2a6e"
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
