class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.5.tar.gz"
  sha256 "f0145d1e51c58df5d1602d632710399f0a3fa850b161f955a8b0edb023f02fde"

  bottle do
    cellar :any
    sha256 "6fae836feb5c6c4feb9ef9a6a25b6b36ab851fecc5de45eb57aee4bff138e280" => :el_capitan
    sha256 "290997562d18b42dd30fd879fa9308f91e2f57f9f9cde5bd22a4687afba0c0d7" => :yosemite
    sha256 "8fbc956d0e4116f9a597dd028ca26889db9857a8773b033c9298a0f6989b0f46" => :mavericks
  end

  depends_on "openssl" => :recommended

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/blob/master/docs/Usage.md
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
    (testpath/"hello.html").write <<-EOS.undent
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
