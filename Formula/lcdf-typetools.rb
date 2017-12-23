class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.106.tar.gz"
  sha256 "503c3869f73a392ae0ba41e0fc4f7672e70e2d66e8a81f3bb183f495183fa967"

  bottle do
    sha256 "54a0671edf516355776d087a614b2ae34bd4c45f3a6fc6e8e8cc37eb76d0c395" => :high_sierra
    sha256 "506c5c3094db4572915e4d0148e63e50fcbc1538fdc99dcaf5c5757c566b0d8e" => :sierra
    sha256 "76dd55f25f7bb778507f1aa115f99b72323f61f292462841aaa1229df9bfa80e" => :el_capitan
    sha256 "765f4c5554e9302c9162f887fd227c52bdf3e46602789d6cc52a86f59780e90a" => :yosemite
  end

  conflicts_with "open-mpi", :because => "both install same set of binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end

  test do
    assert_match "STIXGeneral-Regular",
      shell_output("#{bin}/otfinfo -p /Library/Fonts/STIXGeneral.otf")
  end
end
