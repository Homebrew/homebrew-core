class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "ca698d287f8b964a34fa23cf2a8b6039fd5913d6169bbdf90bf90f6b580c8475" => :big_sur
    sha256 "ae3f4bf92f1cbc78a985e8c27979a52c1a4c16696a74bb142a317f88f5c46082" => :arm64_big_sur
    sha256 "07edf35230c5dca07fd5b4aa3a198d9ec706319e9b57ae62259f63d9726262f7" => :catalina
    sha256 "b921f9634055bd7aaab722d156feca35da0742106036f23837241d53d1380648" => :mojave
    sha256 "0ebe3e7a88d400291a3e0a3f46d40b500c1e0487f5f689535c8c468993e786da" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxp"
  depends_on "libxt"
  depends_on "xbitmaps"

  uses_from_macos "flex" => :build

  conflicts_with "lesstif",
    because: "both Lesstif and Openmotif are complete replacements for each other"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match /no source file specified/, pipe_output("#{bin}/uil 2>&1")
  end
end
