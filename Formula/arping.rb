class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.17.tar.gz"
  sha256 "ecb509561b33af07d9fae5401b5eef9a4ef4d3ffc9c906c1274aad172668907d"

  bottle do
    cellar :any
    sha256 "a005ba2601051efc8d3f98ceccbb8cf77a8a08a5f1210e28bf5066b3f507bcad" => :el_capitan
    sha256 "e92439451f6a02fa3b0898f077a2bd1b82dcced99336bf386d6dc56330de7bd4" => :yosemite
    sha256 "9bada1138582acdab04c574ef4056cf8a0be259ba2bbfcd8b4db50aa4c18587f" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
