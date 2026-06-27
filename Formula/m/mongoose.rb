class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.22.tar.gz"
  sha256 "87727cd2c240ff559b16e9710d44b61ba3513dbee50428bd8ee1596d7c58460a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2103fa5a20ba29c0b5d063a876ce4a800c0c46d1ef27a7900f48183d72fa6857"
    sha256 cellar: :any, arm64_sequoia: "31d672a392399bd62409c4fb3358c5b4d9147693769901602c231ab607193bf9"
    sha256 cellar: :any, arm64_sonoma:  "d62b1d5a109daa22556ad5f0c9970f41651f2f84933ecdc985ea2651edee0103"
    sha256 cellar: :any, sonoma:        "76d3c9339f6e6b83a74d4c13d28584436c4ab32f08dda7248290627775fc91d6"
    sha256 cellar: :any, arm64_linux:   "c7e740d499c38f3051c7d89fb54072d781966c42b3118e48d5f205b39e54531f"
    sha256 cellar: :any, x86_64_linux:  "281b9257a1547eaa2ccb651e904ec2298951a5c4495f6eda640fa961a590cfb5"
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
