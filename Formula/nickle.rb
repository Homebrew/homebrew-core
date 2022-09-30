class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.91.tar.xz"
  sha256 "a27a063d4cb93701d2d05a5fb2895b51b28fa7a2b32463a829496fb5f63833b6"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 monterey:     "b1258d434acb09bb06f6a466a0e895fabbe2469c38d45da48ca8fe8a98d64e4a"
    sha256 big_sur:      "6e377f6674d6609f634b28941d8c53fef94c9cb429f31d1c765e4a5d8607e88d"
    sha256 catalina:     "3e1d028467ee41d963e9eaa9809f288fbc3effd826e09ae69bd4e4bfd26679c5"
    sha256 mojave:       "6fa77667c30e0dfa186868159076bd2e003c34d32624915481f8c52e68b97f23"
    sha256 x86_64_linux: "a80572816adbeb145a3dd76b327bff79653d6ff504eba14b9fb767e73c64a992"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "readline"

  uses_from_macos "bison" => :build

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
