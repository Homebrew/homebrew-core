class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.16.tar.gz"
  sha256 "1f20f2781862560ddf3203dfb0e6fcf248a68bf92aefbeafb9d2a629c4767c02"

  bottle do
    cellar :any
    sha256 "b5030cf46705161bfedb5c7ab2381fdd6e5fae5fff949b88192890baebcb6799" => :mojave
    sha256 "ee6d527c83cc3ceeaab865b57e252fa586ff688f7ad621d8f888f0099abdc620" => :high_sierra
    sha256 "f8804407c6e9db55ff09309fefd98559564de2827d0240c7f26b6aa9d559c30c" => :sierra
  end

  depends_on "openssl@1.1"

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
