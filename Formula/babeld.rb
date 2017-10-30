class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/babeld-1.8.0.tar.gz"
  sha256 "11a8b1224fb82aa1a0b7060cd7af488c22102384acc4ea46bf192c2db69a526c"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dab41722a62b7983230dfb88928bb438ff87080fe2ceed17c9ddb459b726052e" => :high_sierra
    sha256 "d384ced16e50c28eabac680e1b7f95b7863d6d6a8cced97e96c783b3a6860a23" => :sierra
    sha256 "52fe6dc33f81bce43054f00386b19a56f3bb9c153920dfba2236a239df84e5ab" => :el_capitan
    sha256 "be20af1a2505f188d4a5e32a3793542db187d9ec8ed85a33909616e59d775f4e" => :yosemite
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
