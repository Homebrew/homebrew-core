class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20160522.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160522.tar.bz2"
  sha256 "de77430ae90db4ec3851cdfc95d842b9d1e7e28e46e8d40d49bd17def53c200f"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d263d75bbcf5bc287c5097176f3d062ec9943745282d164729b115a0d59709e6" => :el_capitan
    sha256 "aa06fd80b943c128b265d3404c211f5947897845b816fa8b0f9e3a46da933e85" => :yosemite
    sha256 "329e9c9d9a44a7b889729bc4c2dfc8259039d3877d291287a54b8d89e03dd6d5" => :mavericks
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
