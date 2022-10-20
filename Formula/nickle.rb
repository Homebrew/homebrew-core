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
    sha256 monterey:     "372a728eaa440022fb6cf28a8a2e4f63171e202efd1d6cc2ab91c934d4f84423"
    sha256 big_sur:      "135347f40925ae8ff735756acbce9a34d214b4edd489355e8fd1579c716b4657"
    sha256 catalina:     "10005a33c40d894911d86bc45ad8671eda24d63d2b4117b61540e6bcc6ac1a85"
    sha256 x86_64_linux: "3350bde797ffbe319c870163dadcb69d413fcf6c50c75ab88e3e5d5977ae0034"
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
