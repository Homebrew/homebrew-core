class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1-src.tar.bz2"
  sha256 "9b5d68bf1874a7b393432410c7e8c376f174d2602179883845d2508152153ff0"

  bottle do
    cellar :any_skip_relocation
    sha256 "348b4b8c905eebcb4b981348beace630806e7d22bec5f52c345946c41579a85e" => :catalina
    sha256 "5a5d075b298e34c2ac5c0324675f8163cdff0f906d1cb38848640394ff1f66fc" => :mojave
    sha256 "d6614f82109ed400dca5a0215d256c522c47480e63fe36196570fec8ad0dcbe8" => :high_sierra
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1.zip"
    sha256 "d463ad11aa191ab5ae64edb3a439a4a4a7a3e277fcb138254317254f7111fba7"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
    ]
    system "scons", "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
    system "#{bin}/makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
