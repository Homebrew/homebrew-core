class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.28/gphoto2-2.5.28.tar.bz2"
  sha256 "2a648dcdf12da19e208255df4ebed3e7d2a02f905be4165f2443c984cf887375"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "0a2a57995067c69118a232642dfb89cd3e3040706f768e1102160ba07d5ee000"
    sha256 arm64_monterey: "f539f391b11d94317e0c1b693b0f8ed0abfa1a702111c2a8807ae17be5890e38"
    sha256 arm64_big_sur:  "2c28a56b1840d21ca1044b9aa3a39b66ecda08dbb1ca3f6b762eb31450bce5cc"
    sha256 ventura:        "377d87c61e278de33dba27cf90c847de972a5b838f50fbb1dabf37255dc6729e"
    sha256 monterey:       "5ed1d4e739a9714fd521dab770b3f0158aa0f0e7ddeee83df73cbf29d7e00ff2"
    sha256 big_sur:        "ea0442d95d2eb20d04a01a70193130523501a977f8b6c90a151f4d79f27da454"
    sha256 catalina:       "50f8ac20116d922be552822446f438296df99e104509ccc3f9785576d7c01016"
    sha256 x86_64_linux:   "52adb4dfc3a7c3b062ff23a25adf8ddcaaead4cef2df8e1e355067fb124f4873"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
