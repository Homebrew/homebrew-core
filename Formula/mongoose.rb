class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.9.tar.gz"
  sha256 "d316b24d4ed23851d81b0ac4e5285b778c684bff27f398b01f779696e5b2711a"

  bottle do
    cellar :any
    sha256 "82c235d005c41204ab5180eed6f9fb0ccec267194303169fa48b0d8ae676f6f1" => :high_sierra
    sha256 "301825dcf89cb1d176cd068415bf817d9d6ee701b1f1c434dd6970190a2b860b" => :sierra
    sha256 "c6916fbd4d4e7ce60967e65f19159a337e5037adc40318c982e3ba2e20cd9436" => :el_capitan
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
