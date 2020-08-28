class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  # Version 20200822 is considered beta software on macOS
  # See http://savannah.gnu.org/forum/forum.php?forum_id=9800
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200722.tar.bz2"
  sha256 "4801d44f2f71eed26386a0623a6fb3cadd7fa7ec2b5a7bbc5b7b52e2a0450d6f"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a78bb25a7ab4168c770d1bfef742afffa6c35229ca96ed0ad8135113267d99c" => :catalina
    sha256 "3ba75a7522a91db40082095066738a93d7b92e24c1ed49815a528be475565eef" => :mojave
    sha256 "dda2ab83abf9acb274d260ab9b2c0751f1a0e99c31a579f50dd6846e3eefc2de" => :high_sierra
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
