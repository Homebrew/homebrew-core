class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.05/nsis-3.05-src.tar.bz2"
  sha256 "b6e1b309ab907086c6797618ab2879cb95387ec144dab36656b0b5fb77e97ce9"

  bottle do
    cellar :any_skip_relocation
    sha256 "348b4b8c905eebcb4b981348beace630806e7d22bec5f52c345946c41579a85e" => :catalina
    sha256 "5a5d075b298e34c2ac5c0324675f8163cdff0f906d1cb38848640394ff1f66fc" => :mojave
    sha256 "d6614f82109ed400dca5a0215d256c522c47480e63fe36196570fec8ad0dcbe8" => :high_sierra
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.05/nsis-3.05.zip"
    sha256 "3280c579b767a27b9bf53c17696cba550aed439d32fac972fe4469c97b198873"
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
