class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20160622.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160622.tar.bz2"
  sha256 "afca50eb4711f60bb3e52efb2fc02bf9ec77d0b9f7989df306ab5ec5577ab6ab"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "421bf3c3f5dc9ed02bd547fcc0dd17840cf00746b28ad6f38009b829515a4631" => :el_capitan
    sha256 "ed566d860296a06d09760936a80900f1ce520f83275916d4f505215b3d5c26f3" => :yosemite
    sha256 "cc93ff4ba1288030ba27c11cd930e02d383cb4c36d766ff7e0845db8ec324b2d" => :mavericks
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
