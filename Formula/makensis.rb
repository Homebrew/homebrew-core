class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04-src.tar.bz2"
  sha256 "609536046c50f35cfd909dd7df2ab38f2e835d0da3c1048aa0d48c59c5a4f4f5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e7cb0cf276e20c96b426188fa69b9a70aff58419747633682be8a957a4c6c166" => :mojave
    sha256 "c4cd3ba5be94d0c9788997dd9d686b7868519ba2c631e215bdc1eac1ecf63ed0" => :high_sierra
    sha256 "8f035781e4e926b8dcd367fbdc3a3a2bdd9b5fd96d268da62e9ac88ada495137" => :sierra
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04.zip"
    sha256 "22f3349fea453a45551745635c13e5efb7849ecbdce709daa2b2fa8e2ac55fc4"
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
