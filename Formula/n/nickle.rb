class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.93.tar.xz"
  sha256 "a8dafb5f3e42528c212046a24559cbdbcb5d197c71b24f3e61543b85d3842beb"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d0d6255b9d3fb675313e9cffadbfc052e0277b7da6e89940c00c3154f349a5c6"
    sha256 arm64_monterey: "519e19dfb3e6d0f240d9f9403e1d81fcc70058685dcd855d74d44373bf602204"
    sha256 arm64_big_sur:  "235c2dc6123664e5ebd6357aaeb03fa9ab581607cff8d92c37e39b22585641c3"
    sha256 ventura:        "2e40cebbf8c374d255374a28204b5905c650bd7a3653f921e585b5ef3085ba14"
    sha256 monterey:       "bbd70d1d86297d8118ce157f99b588eba33e3b086356d20405f1bb6d1ee45e74"
    sha256 big_sur:        "2920ed867e365086f38766c1b2df9d523f27046b02c50e88a5a454a41cc2ce13"
    sha256 x86_64_linux:   "0ded2c09a3d1e1bcfb36d5d7fc0b0e2bf78354065b02a0c8927535f00b846a41"
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
