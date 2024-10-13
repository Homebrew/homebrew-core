class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://mongoose.ws/"
  url "https://github.com/cesanta/mongoose/archive/refs/tags/7.15.tar.gz"
  sha256 "efcb5aa89b85d40373dcff3241316ddc0f2f130ad7f05c9c964f8cc1e2078a0b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "22a4f3acc392f97710bbb2eb7b2a8652deb0e32c42a2372a273a97c780bd7654"
    sha256 cellar: :any,                 arm64_sonoma:   "8fa426f24794e047d6b2ef627e70d7469dab6004b63a2da262273fabbf6fdd08"
    sha256 cellar: :any,                 arm64_ventura:  "2f01277d6d1f691ad4dc55a26251a56fae6b85fdc4abac97fe19804b2cb700ae"
    sha256 cellar: :any,                 arm64_monterey: "e796a72aa7601a0573f63e5d822fd24c018c4f2f49ba9c62fe9500f62a184e3e"
    sha256 cellar: :any,                 sonoma:         "8b4feba3ce4d790de7cb53461a252769c86cac32c0ab676782856400ac73f9b4"
    sha256 cellar: :any,                 ventura:        "2cc1fabb8af18a789cd2a90a64f31408306a02c65abc94b01c9682bd4c5fb54f"
    sha256 cellar: :any,                 monterey:       "5ad700fcbe8d2be7f2ba8be80196cf47306d3c65d05d4293f8e756d2935eff2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3faf77782983cb1c0e662afb1321326c2742e656bb6e8af8ab678f9a417ae3a"
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
      pid = fork { exec bin/"mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
