class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/babeld-1.8.2.tar.gz"
  sha256 "07edecb132386d5561a767482bc5200e04239b18e48c2f0f47ae1c78d60fe5dc"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34f5992046489bd70733203a0c5f4583553a057989551f6ed917cd852ab3c5c4" => :mojave
    sha256 "f0ff0f699974757e42a82a33d932bc72d0dd75a1f3f48a392594258498f9151f" => :high_sierra
    sha256 "ff8c0a94366c55ca90190fc42c8d0856db5359f9d8f1ff2646b11b09252a17ae" => :sierra
    sha256 "a4dd075f51dcb309632f19761340cd7bafc7fc14f69f8f6acfbcf7e360dd0f2a" => :el_capitan
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
