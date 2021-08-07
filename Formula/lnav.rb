class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.10.0/lnav-0.10.0.tar.gz"
  sha256 "05caf14d410a3912ef9093773aec321e0f4718a29476005c05dd53fcd6de1531"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6b79f37c40cf7a626865ffef75bc445813d91473d64068e6d906eb3cedeeab4a"
    sha256 cellar: :any,                 big_sur:       "11eb34ef34f635e008facc8890c0bcb07585d62dd9c273890552890d863adf0e"
    sha256 cellar: :any,                 catalina:      "b21b188394092e3ca801819e0b2eb26017132fb2baadfcb014d6fb3c8c6253e3"
    sha256 cellar: :any,                 mojave:        "49510aa07d98f6a05f6d7ea19dc30f2ada6456b3fb644620efe1e7e3c92673b4"
    sha256 cellar: :any,                 high_sierra:   "538a2a0b9f09829b33901bd33e5d8f566745f23a3d3fe95d6fa7f6608d3bb485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb21285186fdb65393a3fab4eb29ea3d0bc26d4c6f68e07571e250b5b70ae19"
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
