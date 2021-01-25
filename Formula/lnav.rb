class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.9.0/lnav-0.9.0.tar.gz"
  sha256 "03e15449a87fa511cd19c6bb5e95de4fffe17612520ff7683f2528d3b2a7238f"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "11eb34ef34f635e008facc8890c0bcb07585d62dd9c273890552890d863adf0e" => :big_sur
    sha256 "6b79f37c40cf7a626865ffef75bc445813d91473d64068e6d906eb3cedeeab4a" => :arm64_big_sur
    sha256 "b21b188394092e3ca801819e0b2eb26017132fb2baadfcb014d6fb3c8c6253e3" => :catalina
    sha256 "49510aa07d98f6a05f6d7ea19dc30f2ada6456b3fb644620efe1e7e3c92673b4" => :mojave
    sha256 "538a2a0b9f09829b33901bd33e5d8f566745f23a3d3fe95d6fa7f6608d3bb485" => :high_sierra
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
