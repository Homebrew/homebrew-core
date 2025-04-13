class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.17.tar.gz"
  sha256 "b6a6f69912c2cd0c67f85633c6b578d4dcdf385c3628acdcd21de28787c676e5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7da67987c2601a85ef6a8fb31d271df8e88582b157371dd26bc4f920d7592bf"
    sha256 cellar: :any,                 arm64_sonoma:  "429001b79c2fb2e12ce300294c6ce4ab91c4d185378246ff012c59ef0b7e6434"
    sha256 cellar: :any,                 arm64_ventura: "c46ce284b116d0724884adaeffed83f45977a77ffa0fc95c29b0dedb9af2f69f"
    sha256 cellar: :any,                 sonoma:        "f660079a2c16a85cee9f5eae7ba8a471aae39c2d8e06bf12e15e73043f8333b4"
    sha256 cellar: :any,                 ventura:       "3cedda3660d3c3402437c936a5786d2d80f3fdcb5ad1654581a47c000e975499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cecfabb0f8ec0a12573cb00814dc99b83e6f3cbac2c84310fb343cbd3534026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497858a95dcd1814149278dd48f62d2d9e58a58137562b52a3c29bab1a33b6c2"
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
