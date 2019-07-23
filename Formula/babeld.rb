class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.8.5.tar.gz"
  sha256 "202d99c275604507c6ce133710522f1ddfb62cb671c26f1ac2d3ab44af3d5bc4"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da7219b20803375eeee3c72bc7bbbc554c36622979637a270f172a082ab889f2" => :mojave
    sha256 "dde61f34a3ab1e3ed0107bf2e94c0cd6d53719722a9b612aefdef514288434e8" => :high_sierra
    sha256 "d6658a6164f3280484143d21c2e8ef46cba9f327eb86e0bf2435f879b0393e9f" => :sierra
  end

  def install
    system "make", "LDLIBS=''"
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
