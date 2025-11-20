class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.20.tar.gz"
  sha256 "e971804cd22fbbaef03600fb6100023446e29386dedfd6cb2b3f06652544b7ba"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "811150b16e4dd4a6747e92e83f63340ca31c4e6d042fb307cb145820a64c9bf5"
    sha256 cellar: :any,                 arm64_sequoia: "6720fbe30dd982529ea75bd51dcf74ac79803027762693a6b7f78324e6942c29"
    sha256 cellar: :any,                 arm64_sonoma:  "5cdd7fface33823823328e34a7a4dd53d03c1511b7eae935f4e3d15833dbc8b5"
    sha256 cellar: :any,                 sonoma:        "4bd98a3a8c27be0e5c86ee34eb0d65f7aac3621f3b08e3dd9d95d7f5d633481c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6296e92ee63ca83a980a0f4b122703a0dac0bc9638ce2c7ca8aaa86d0a548c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e02ac4d9a40bd8cdda354dcc2939dceee56eb604efb65cc5510d0df9c359cf1"
  end

  depends_on "openssl@3"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "tutorials/http/http-server" do
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
    pkgshare.install "tutorials"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    HTML

    begin
      pid = fork { exec bin/"mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
