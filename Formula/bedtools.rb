class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.27.0.tar.gz"
  sha256 "e91390b567e577d337c15ca301e264b0355441f5ab90fa4f971622e3043e0ca0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1ae7532f9807d9cc62c16b521fa651364a1558ae239149e28a20212cde840a0" => :high_sierra
    sha256 "102c52ec8ef73ae63f1708f8f5ce60cdff3b927a9e75505792f6975298e819f8" => :sierra
    sha256 "81f150990e63eb1c08869616ab123a724feecc17c948cd1676a817c86fbcc16e" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    prefix.install "RELEASE_HISTORY"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
