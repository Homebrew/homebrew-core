class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.24.tar.gz"
  sha256 "0b21cc2ac2a094600d58f2bd20d42aa21ce88375adefc32af481fe89997285fb"
  license "GPL-2.0-only"

  bottle do
    manifest_sha256 "312a3bedd563300093d77cafab17f919d6e9c43af005d899dc5d4334551e9e76"
    sha256 cellar: :any, arm64_golden_gate: "7554043843eb9a94924ff1d88874b31b5935ab8e0c5f9a383f2b077c286d1888"
    sha256 cellar: :any, arm64_tahoe:       "29dd52409ce1581a5b9d27b5b69d466704e304f0343e2af67fb2b51903e3a079"
    sha256 cellar: :any, arm64_sequoia:     "c3c051f280bf68d0e34c0a10ca15e807c17a98f4b4680ae0cbb816f0902175ce"
    sha256 cellar: :any, arm64_linux:       "c3a62ba94bd803666248723d5167bdb5f643747cd9a26ccc38cc7c622177843e"
    sha256 cellar: :any, x86_64_linux:      "dd6b3a2188538317f4e7597007fc2cfa727ef6b9d516d7a35388d59298af597e"
  end

  allow_network_access! :test

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
