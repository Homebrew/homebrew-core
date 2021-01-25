class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz"
  sha256 "629e31cf1da0fa1efe4a7cc54c67123a68f5024f3d8e864a30457aeaed1d7653"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/tjko/jpeginfo.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "27bb3588438853fb065ef36885dfea66a2e066dddc7025ea8fd6295682ff8b83" => :big_sur
    sha256 "883d13008806a89bd05f612ffd27940a5985f47ad9c950af76f719b6a781bb1e" => :arm64_big_sur
    sha256 "0f0cc493a38a1a701a51f6aa2cada9b8f248c228a72ce30c451d5cab2906e8c5" => :catalina
    sha256 "71cbeda00d00f513847a88930a6851b00ab9811fb6ed37d0617eaee5e86decf3" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "jpeg"

  def install
    ENV.deparallelize

    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoconf", "--force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
