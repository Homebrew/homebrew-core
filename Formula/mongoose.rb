class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.12.tar.gz"
  sha256 "cde4f61bf541c0df7507c5f138d0068fc643aea19ab3241414db2e659b71ddb3"

  bottle do
    cellar :any
    sha256 "f03da6ce9b67eb2e7bf29fd1c54b729eac7da0482915eeb03c7a6671b1143240" => :mojave
    sha256 "b55ab50af9bea08d026102370b6bf9b24d9d1926caa97dddf8a47520ff69d3ce" => :high_sierra
    sha256 "a71f64a6f888bb252486be06bc75bc02d5f7ec8dee799300fe49653ce914b4ce" => :sierra
    sha256 "e80290df08f6d557b0fe750c882de3d87c0edc2ee12853afd3628d06c26147f3" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    pkgshare.install "examples", "jni"
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
