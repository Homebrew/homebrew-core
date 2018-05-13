class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/babeld-1.8.2.tar.gz"
  sha256 "07edecb132386d5561a767482bc5200e04239b18e48c2f0f47ae1c78d60fe5dc"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9851d9aaecaa46680cf57cde463619dbd9311d85fd9df39de9a26e7aefa0f013" => :high_sierra
    sha256 "d54052f62eed542a4deea14721c0fa731b034e34a17565c72e397403134410b6" => :sierra
    sha256 "7e288b1ce8d4efc3d1a652fbac8a4a702af59cf53dc09edff50a22089f0aabc4" => :el_capitan
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
