class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.19.tar.gz"
  sha256 "7ae38c9d673559d1d9c1bd72c0bdd4a98a2cae995e87cae98b4604d5951762b8"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "346018555ea9ef1ecc95dacc5dec337dbb4c0cad3502c275f8f3036fec3116c1"
    sha256 cellar: :any,                 arm64_sequoia: "b6560ca28dce7662d81ff3996887775310a25a43f855d437e2ff2aac8127e7bf"
    sha256 cellar: :any,                 arm64_sonoma:  "04c4fa0e7342e96d3b75224f9f74b7571387c0cd6c4865e310611182317828d0"
    sha256 cellar: :any,                 arm64_ventura: "695f0f8fc7e7700b8021340fbe7c49ade0c2178be7907a23477d7d13ccf58a1d"
    sha256 cellar: :any,                 sonoma:        "4a6c2ac51634fb5cbe5586af62bee3ca83ff836f61fd6f27cfc1bd54220c4cd7"
    sha256 cellar: :any,                 ventura:       "7840143349acd60f2a53cbdf6f9afff05aab257e87a97b2df16ae30970af900c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b08a81ef1304d6036bd901592ec69c61b21bd6edbf66a270843de71763c3cfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5db2b5b0eb82a5bc9735b19f56042b32e6754142a46718d96e920a9bdf93116"
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
