class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  # Version 20200822 is considered beta software on macOS
  # See https://savannah.gnu.org/forum/forum.php?forum_id=9800
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200722.tar.bz2"
  sha256 "4801d44f2f71eed26386a0623a6fb3cadd7fa7ec2b5a7bbc5b7b52e2a0450d6f"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9780021f2b14b631cdfadcfa250154370d6ee21bdf29f46bb2f9dcd99cce3d0a" => :catalina
    sha256 "a120510abfef9dc25e8c00266319a2c2f2f4fd9a31e5213d0701d0de95a66271" => :mojave
    sha256 "85fe0cc7b1c34970adb4a466cd2219e3a92757b63625f1045daafa3f8e2ba50d" => :high_sierra
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
