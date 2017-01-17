class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.6.tar.gz"
  sha256 "ecb67def6ce8182665e8bc5da6a14ba72bc878587d133461da79539cfc8ab414"

  bottle do
    cellar :any
    sha256 "2a29b6494d6e7d38b616ee8f8fabdbcec42377b17afb4eb1d399886fadb2b292" => :sierra
    sha256 "a55500b5747b8629023e0e132794a1f9d6e81b048d52c2bec43444346dd1b552" => :el_capitan
    sha256 "f81a27631658176fccaceaf55f2c93a536bcf21f7f7d18e5aa2d6666ff43f817" => :yosemite
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
