class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.14/gphoto2-2.5.14.tar.bz2"
  sha256 "9302d02fb472d4936988382b7277ccdc4edaf7ede56c490278912ffd0627699c"

  bottle do
    cellar :any
    sha256 "9eb52529f40552c3eba2b808b53eff1df1e656a10d11840a929b2a33952c390c" => :sierra
    sha256 "0e2934121f7ca8161647a59a8cb31346ecf3a52615cb37600d4572a8f1be800f" => :el_capitan
    sha256 "6ed9ca92245da54f0f617ff4aaf6d92bb3d1bb02f42b2bbd26e77f2c6382afcc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
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
