class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.16.tar.gz"
  sha256 "f2c42135f7bc34b3d10b6401e9326a20ba5dd42d4721b6a526826ba31c1679fd"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b99dd5a11b1cc2722a01cdf6ea227382ba43f85f1866c759194b11f4aa3e0170"
    sha256 cellar: :any,                 arm64_sonoma:  "0585d930d3e7e844a196ae762088d5c3dbab3cca1dd9dc5a7c804372d15470de"
    sha256 cellar: :any,                 arm64_ventura: "cf1660db27a14f9cc25a98627028768fedab551a1cdefbd7edfa852366aa568d"
    sha256 cellar: :any,                 sonoma:        "d50c85f28f86bc70b8f6735f211ade27c08ffd957cbb7ab307eddf842ff5383c"
    sha256 cellar: :any,                 ventura:       "4595a19b70fa94727881c59e93971218aa479d771a5fd5d8dd52259473f327d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654c508a99bb309ccd1511cae66fa356b3431a93d52c632cd49257a5ad4893c6"
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
    pkgshare.install "examples"
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
