class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20161122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20161122.tar.bz2"
  sha256 "e2595011494b557822134bd6ad73c8d455764cdf51d148005346a4564626ac7c"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6896586ccf3e15b69d286a55ec9f8a0273dd8e3b1a926d2eedbfe3bf9c837c22" => :sierra
    sha256 "6896586ccf3e15b69d286a55ec9f8a0273dd8e3b1a926d2eedbfe3bf9c837c22" => :el_capitan
    sha256 "6896586ccf3e15b69d286a55ec9f8a0273dd8e3b1a926d2eedbfe3bf9c837c22" => :yosemite
    sha256 "e1e15a092730a4b09381f68bc294eedc666c55f128e5c4f4ccfeb35a62192be8" => :x86_64_linux
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
