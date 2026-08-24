class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.23.tar.gz"
  sha256 "93208f164038b05d156935b8b725063e1afb3984a362dbcf3a9ea37b6f1f2255"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "03a5f71bf23ad471f0fe7352dface9ef16fe83a17351ae92bde850cb7bb8430b"
    sha256 cellar: :any, arm64_sequoia: "da855f57ed5a209b828f81d9b427870e92f3cc861f9dc4366a69a587a16f39d5"
    sha256 cellar: :any, arm64_sonoma:  "a606e227eafc2483733dda6a7443609eb69434d0ec195d0f84c4ff248cecaeb0"
    sha256 cellar: :any, sonoma:        "2b7e2f95b37c22de8dd65949c4e02d9b65dfefa26cb8e09e520b37a32ad5b198"
    sha256 cellar: :any, arm64_linux:   "dda4bf159cb7d12217c3fe2ad44215c4b578e7ec5acaffa6f158f2cfdca1194c"
    sha256 cellar: :any, x86_64_linux:  "290d39e1f09d2f9e40fa650569d6aa5bcfc12f2b759c0621f361d1ed25ddcf1b"
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

    # Remove tutorials which have binaries built for a non-native architecture
    rm_r pkgshare/"tutorials/stm32/nucleo-n657x0-q/" if OS.linux?
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
