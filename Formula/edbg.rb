class Edbg < Formula
  desc "Utility for programming ARM-based MCUs though CMSIS-DAP SWD interface"
  homepage "https://github.com/ydesgagn/edbg"
  url "https://github.com/ydesgagn/edbg/archive/0.6.tar.gz"
  sha256 "f683fb0af805f3e47f3bb0c181ef81ae3ddbe390f360edf64953ef4ce181bf47"

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
