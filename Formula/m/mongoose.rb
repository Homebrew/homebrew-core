class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.18.tar.gz"
  sha256 "8b661e8aceb00528fc21993afe218b1da0f0154575a61b63ce0791ad8b66b112"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9b6257a6f94c7de3aacf1d0910fb64040e936276e857a3e39f07719877f9f00"
    sha256 cellar: :any,                 arm64_sonoma:  "404c20eea42f1a4f82a71b24fbd6f86dc852f165c3b05888c61157c65c641fec"
    sha256 cellar: :any,                 arm64_ventura: "a8ba96bd0932872b97b66f17f3b2b5adcdf5c37cce8f38547207707df910181c"
    sha256 cellar: :any,                 sonoma:        "aab6085231ab726182a67b541750d8004cfe7907bed8cd645284e417be7f143d"
    sha256 cellar: :any,                 ventura:       "5e340bb65e242915f274093e833ebfabf4db89c678ea2eff3d663f677ce7dcea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb1f43f42d51a855ec0b3de2893f72dac92f3bc1a9985907bf2353f7f8cfe3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7e641817714cb791b70ed13d943e33a17247a975ea054949b66266c55fd463"
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
