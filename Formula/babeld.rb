class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.9.2.tar.gz"
  sha256 "154f00e0a8bf35d6ea9028886c3dc5c3c342dd1a367df55ef29a547b75867f07"
  license "MIT"
  head "https://github.com/jech/babeld.git"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a7bb20a1f278ab2acc151622894d0e96ee81e9a9a0e53c1ecc9565f5906ed172" => :big_sur
    sha256 "6a56133eedc55610cbd65c8862584e2a109702e6f6c3619c58bcc99a41c99da1" => :arm64_big_sur
    sha256 "1e311a15868154bf204fe2d9d19ed1db24c830fcf9cfaa32cf1255d7ed35b108" => :catalina
    sha256 "1ddbacdd3433b008c2ad86e582ab2376cf0bab93b7939bb9f47d6e1e1fd06ad3" => :mojave
  end

  def install
    on_macos do
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    end
    on_linux do
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    expected = <<~EOS
      Couldn't tweak forwarding knob.: Operation not permitted
      kernel_setup failed.
    EOS
    assert_equal expected, (testpath/"test.log").read
  end
end
