class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.4.tar.gz"
  sha256 "500ff1010bbceee26d4ce1b991515736bd8c0ae6894f8c38468c05c224fe7c25"

  bottle do
    cellar :any
    sha256 "230274403aefedd59f70c0af9b162a88c40a51052d1d810b9e55fa56afbfaccb" => :sierra
    sha256 "1da66894b7596c4e51c9515f493b1615dd6d69cd8c0c01587d7bc0aaf6545e95" => :el_capitan
    sha256 "fa5bc38a5573eb9dfbde7210ad850ff49e5a2dd78d1c128c8831ccbb55951c1a" => :yosemite
  end

  option "without-test", "Skip compile-time make checks"

  deprecated_option "without-check" => "without-test"

  depends_on "doxygen" => [:optional, :build]

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "test"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end
end
