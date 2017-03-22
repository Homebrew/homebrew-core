class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20170322.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20170322.tar.bz2"
  sha256 "f8f810040088bf3c52897a2ee0c0c71bd8d097e755312364b946f107ae3553f6"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ed5a6be95787e1f0aca6f0e74cf446df11f36e2ca976d5eacf84df639d8c235" => :sierra
    sha256 "8ed5a6be95787e1f0aca6f0e74cf446df11f36e2ca976d5eacf84df639d8c235" => :el_capitan
    sha256 "8ed5a6be95787e1f0aca6f0e74cf446df11f36e2ca976d5eacf84df639d8c235" => :yosemite
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
