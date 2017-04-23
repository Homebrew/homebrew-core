class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170422.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170422.tar.bz2"
  sha256 "7a2438a92692c662dae3d4e80f1190af4cfe527cd3fb1a0d14e07f5c110ed329"
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
