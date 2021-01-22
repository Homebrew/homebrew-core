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
    sha256 "37e82024df11755d6cd35632c10f2e44ea3185e9ef1eb3ba667adeac19ab8b82" => :big_sur
    sha256 "4f8a2d17314ebbd685c9cf68b74621942902a75817ece179c2c4a36f95018ab1" => :arm64_big_sur
    sha256 "d65c7dd41ac16cb2f791a80f3cbebdb6616321e106874504644b0ab5cd37da24" => :catalina
    sha256 "14f512383b868d8c9752414328fd4681de70d6aa37992cdcb55be61406bcb08a" => :mojave
    sha256 "6b920612afb160b31950f28dad5b38880689cb3f52a23be723e8dd680370fca8" => :high_sierra
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
