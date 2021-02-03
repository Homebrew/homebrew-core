class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.1.tar.gz"
  sha256 "f099bf7223c527e1a0b7fc8888136a3992e8b5c7123839639213b9483bb4f95b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "87374bf95a515e72a2dee8aeb0a9b4d60c42397e7bcd1bb12ed527165f992cfc"
    sha256 cellar: :any, big_sur:       "8a91713981f4927eb9723d2b5a6b4262185c8e4cf4fe9c02bf7c6f49d7fcab80"
    sha256 cellar: :any, catalina:      "4f7959dac7c0258f3de40d371b166dca99b077e2856a16bbd4baab7b34527990"
    sha256 cellar: :any, mojave:        "b6613ccdbe10010e0ddc4bc9a2b0edc169ac7a6f7e9bda4b5f471ccc4efa8fe2"
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/http-server" do
      system "make", "mongoose_mac", "PROG=mongoose_mac"
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
