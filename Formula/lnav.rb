class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.10.0/lnav-0.10.0.tar.gz"
  sha256 "05caf14d410a3912ef9093773aec321e0f4718a29476005c05dd53fcd6de1531"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "689f5a6514b114b7bc08e41b92dd146cf37db4d8e129bd08ad3002c93d739402"
    sha256 cellar: :any,                 big_sur:       "a3b4186894e82c09c06c49f1e86f43fa829c6aebda2abd125a2c90e4202b02b6"
    sha256 cellar: :any,                 catalina:      "87b9c1b85678d964076f0d2a622330a121b15058751de52d4d3802118983165f"
    sha256 cellar: :any,                 mojave:        "f40a8164360104c3078d17b78ab5ad109437fbb84e7db487a68ad4ed3ac8391f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5d6c89163a52768fd9ac42d9c3a45737cc87b7a0beb80cc1e4193ad95c0158"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    ENV.append "LDFLAGS", "-L#{Formula["libarchive"].opt_lib}"
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "LDFLAGS=#{ENV.ldflags}"
    system "make", "install", "V=1"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
