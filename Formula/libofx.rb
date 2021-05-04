class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.10.2.tar.gz"
  sha256 "7164fbe6c570867296f38f46f9def62ea993e46f2a67a9af1771d8edb877eb18"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "861b8fb76b2bd4298a963658ecc0ead117f9af3bea1d3b332c23eb61ee39e419"
    sha256 big_sur:       "0fda24cb66fe8af710eb7b23690d2ae07f58d7ae2fe7cbccfd8545e046bc2a4d"
    sha256 catalina:      "1ab29be73aad351a947facf5885936680c931750033c1cc591482c51668efea2"
    sha256 mojave:        "a50a4ac4ab568bcbea83c3769b3cb7fd63bfa0f38511295de0fa9a1eb87c8526"
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
