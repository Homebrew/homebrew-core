class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.0.tar.gz"
  sha256 "28206185873b5c448765f56e54d86a7af5a856b0b5f241aa44ac94bf34af7eee"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "b1f736d5106f68eed115ae3f50d667ec44c8ff8a1d02ebf6efac3ba152e2dfca" => :big_sur
    sha256 "079086ee717a75294dfe3b496a3df9bce9c8bd9746f83e21365bea779cc5616a" => :arm64_big_sur
    sha256 "25df4f89726dc160cedb32c52637bec57a3fa7d5d42d8547c0c645a198463590" => :catalina
    sha256 "72d7bc75f0155330f362d15ef9604a9d2cadd39f63891b29e22f3f16becc0c7b" => :mojave
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/desktop-server" do
      system "make", "mongoose_mac"
      bin.install "mongoose_mac" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
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
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
