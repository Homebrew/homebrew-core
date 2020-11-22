class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.6.22.tar.gz"
  sha256 "437536acb02258f8e2cd1e63c801428c65e1c33100e349acbf718c5b04734bd0"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git"

  bottle do
    cellar :any
    sha256 "2be9a30b9a972b4f05b57dc7ca919eb42c84331b01ca0756ad8ad7fc237a8357" => :big_sur
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
