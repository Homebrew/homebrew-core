class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/dejagnu/dejagnu-1.6.2.tar.gz"
  sha256 "0d0671e1b45189c5fc8ade4b3b01635fb9eeab45cf54f57db23e4c4c1a17d261"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c8699cac95a51707a687e2a43de55517c9c19a49cdb34ea70a6ce869ee4ba4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bad10e6433487c43ec72f99cee16123953b6834ab714302474b5135b99a9ed5"
    sha256 cellar: :any_skip_relocation, catalina:      "894df4a4de1df0698f3539db58615fa63bcee77f723eba6efd8d1700ce0bb827"
    sha256 cellar: :any_skip_relocation, mojave:        "eea1adea3a1c062fd6ba0e85fefebe9f9036736a9d3a3744cec79123390270f3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "eea1adea3a1c062fd6ba0e85fefebe9f9036736a9d3a3744cec79123390270f3"
    sha256 cellar: :any_skip_relocation, sierra:        "5c1100eaf8ae4f28b1c4311241ddff8e0d195d0d241e106051bc60490d28d0e5"
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
