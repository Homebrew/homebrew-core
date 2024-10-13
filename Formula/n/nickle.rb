class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.97.tar.xz"
  sha256 "cde788af96f4cef72da26c60cc9917b1b3d05b7a82347c92645cdfe665e84eb5"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "3abcc077797e31d2f31e328e30c1ef7153c40309188b1b29ff9243b8b59dbc5d"
    sha256 arm64_sonoma:   "06ce54ef4e9cc8659594d9b7cbc237bc1fee359879e182065b5c37a6d4de67c1"
    sha256 arm64_ventura:  "414a1b8ab2c399266c6d75ce56a01631497d6085af5a85b96ea9a5c8bd87e422"
    sha256 arm64_monterey: "6542cfb65ae60b1c894450498a82c019288985d44c3c041a019c6b5e49f6a063"
    sha256 sonoma:         "c6baac34a666025e15dd50ba7e17022fa4d2bd23eb70d85de07478d8c4b6f5ae"
    sha256 ventura:        "8222cc7a00991cb26dc6d5ff5a6fd57f038e7345dc8dafb7c0f2e053613850ec"
    sha256 monterey:       "6e42e825376fbef14a54303e292e81bd74536b854e77e222287a0938eb9d989c"
    sha256 x86_64_linux:   "c7aa3dffb100431a09ce1474f5e6f0076378600f94e368ecbe6e59f1fd7adb6a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
