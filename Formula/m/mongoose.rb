class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.21.tar.gz"
  sha256 "d4ddbd12c12f223abefcc0a74417a638ae5c118d7cf10ba546553c6b0e0b5ada"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9e73fd7170840d627053d5e92474219e36168faed700471b6e2514e1a35a74f"
    sha256 cellar: :any,                 arm64_sequoia: "5081c1f0b966c15abc612a788bf718eb253a5a4eb643652a966c37db7e2e3f0f"
    sha256 cellar: :any,                 arm64_sonoma:  "ce5776cff5b9ee6423dfc88d3171341a7635d13814bcd1ad64734852fb0b7150"
    sha256 cellar: :any,                 sonoma:        "214013de2533be9ad3a210551617d328d8086198b666597f0d2219f0afa13655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8378b416431c43d5486fc6ccfaa85168a8c7ddf0a541603bf0ed01dbea5281b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33c503bd19499b37d942517704bdb19d05b1a5ad1628bc2e7502f217f22066d"
  end

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    system "make", "-C", "tutorials/http/http-server", "example"
    bin.install "tutorials/http/http-server/example" => "mongoose"

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
