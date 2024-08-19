class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.14.tar.gz"
  sha256 "7c4aecf92f7f27f1cbb2cbda3c185c385f2b7af84f6bd7c0ce31b84742b15691"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9139ae60d33a7a6f1cde266b0b36ebd6ad4bb0b64461f5e00096ae6ad3893a6e"
    sha256 cellar: :any,                 arm64_ventura:  "73e48748cd2b02596a228b760bbca2369184dc6902b0fa100b218f79b70b6981"
    sha256 cellar: :any,                 arm64_monterey: "655a8b98ec682257158274208686e4e51f53c9207810fdf94d70f056c0789ce8"
    sha256 cellar: :any,                 sonoma:         "b8587f3fd232d8362cc1a18aa6246fa0d3774d6d0f1fae1b720612205b88e51a"
    sha256 cellar: :any,                 ventura:        "68bddc1bacad47e7b48437e841d94707a9e5cdd15a9aa360280e38119c111662"
    sha256 cellar: :any,                 monterey:       "1488dc6df62d74d2f77a21dba9882b364d91ac1883399c0484aeab0be6b39e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4a593ab08328030b3b998b48f988467e55df0658c6fffc3aab7a30bef21258"
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
      pid = fork { exec bin/"mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
