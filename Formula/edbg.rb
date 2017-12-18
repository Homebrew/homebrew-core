class Edbg < Formula
  desc "Utility for programming ARM-based MCUs though CMSIS-DAP SWD interface"
  homepage "https://github.com/ataradov/edbg"
  url "https://github.com/ataradov/edbg/archive/master.tar.gz"
  version "1.0"
  sha256 "89867bf79d936143c7b99a36d284ebeb99dc85ce39fda50cc0c85387dadb1490"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "make", "all"
    bin.install "edbg"
  end

  test do
    system "#{bin}/edbg", "--help"
  end
end
