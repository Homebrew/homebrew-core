class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.6.21.tar.gz"
  sha256 "7ad5dd6a7c226865b5cafe317684e4c61ea95093f943fd46cd896977f234ca5c"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git"

  bottle do
    cellar :any
    sha256 "783bf2b6d71040e8d1a55288e6ea7bd6bfd5cfcac9c3e0850ffbac9dfa7edc4e" => :catalina
    sha256 "602ab449a2352aa7366978cdc7fb57ee1dcf9d8ca8979a8226492cfd85920591" => :mojave
    sha256 "880c24b712d459b4c0a4402ef33b8c96fffd8815f6096dd538f30332c97c13ac" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
