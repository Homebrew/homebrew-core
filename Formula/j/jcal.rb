class Jcal < Formula
  desc "UNIX-cal-like tool to display Jalali calendar"
  homepage "https://savannah.nongnu.org/projects/jcal/"
  url "https://download.savannah.gnu.org/releases/jcal/jcal-0.6.0.tar.gz"
  sha256 "1ff30b55c2aaa8483ce13674c1ed08c4a6cca31bcaa598bd23889c17dbb2a419"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/jcal/"
    regex(/href=.*?jcal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d99b7c820e2ce327574391474b7df09d566a28f100b88de82acf36dd0ba8f3f"
    sha256 cellar: :any,                 arm64_sequoia: "ab7b65b7a25b070edc429eee2bb0d4aa22065ff6a777a7a431ec40e708de6d2c"
    sha256 cellar: :any,                 arm64_sonoma:  "7c190e4905389edfaad628267dd865481b8af78c8d209eb64d287f5697830e61"
    sha256 cellar: :any,                 sonoma:        "ea20664a7760295682e565a5acb888e1cdf97aab562596f82800feb7f31ae02c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5943cf2774a86f3952b141894ce2f455978c5df556fb82367936285b95cd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deca24243279710d9f91efb98dfed609ace40ffd24b4499e76838ddb690164ad"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"jcal", "-y"
    system bin/"jdate"
  end
end
