class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20201208.84cb4c6.tar.gz"
  version "20201208"
  sha256 "fd49aabdd7c7e521c990991dab59700a40719cca172113ac8df693afe11d284d"
  head "https://git.tartarus.org/simon/puzzles.git"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "40e28c1005919ab7dcbb215f5d51abbca00297816e0a4b170f4e0410d17cb713" => :big_sur
    sha256 "9b1eca473055fc6962f69daa3cb7367262e9dadf2a01e3223e1a2e7aff956b38" => :arm64_big_sur
    sha256 "ecdd353296ae643d50a67f5abbdac3d878ab3bc4fcb044b7a9d38b39ac281f43" => :catalina
    sha256 "aaf4ab9bb3026b8749235052b2f82eb7fb3f4eb8ad4ff418ebe35256f0421d99" => :mojave
  end

  depends_on "halibut"

  def install
    # Do not build for i386
    inreplace "mkfiles.pl", /@osxarchs = .*/, "@osxarchs = ('x86_64');"

    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
  end
end
