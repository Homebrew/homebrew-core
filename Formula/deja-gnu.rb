class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/dejagnu/dejagnu-1.6.2.tar.gz"
  sha256 "0d0671e1b45189c5fc8ade4b3b01635fb9eeab45cf54f57db23e4c4c1a17d261"

  bottle do
    cellar :any_skip_relocation
    sha256 "894df4a4de1df0698f3539db58615fa63bcee77f723eba6efd8d1700ce0bb827" => :catalina
    sha256 "eea1adea3a1c062fd6ba0e85fefebe9f9036736a9d3a3744cec79123390270f3" => :mojave
    sha256 "eea1adea3a1c062fd6ba0e85fefebe9f9036736a9d3a3744cec79123390270f3" => :high_sierra
    sha256 "5c1100eaf8ae4f28b1c4311241ddff8e0d195d0d241e106051bc60490d28d0e5" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/dejagnu.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "expect"

  def install
    ENV.deparallelize # Or fails on Mac Pro
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/runtest"
  end
end
