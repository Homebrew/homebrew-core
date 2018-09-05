class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.17/gphoto2-2.5.17.tar.bz2"
  sha256 "aa571039240c68a053be710ca41645aed0239fa2f0b737b8ec767fef29e3544f"

  bottle do
    cellar :any
    sha256 "2eed246e98c89ad02f275548c56b9ef02df5c255b09fe680e244c4a8c0aebb57" => :mojave
    sha256 "1dbc447cbf64977572f5cdb3196b82937f27661f999c9fb7b0ab93985a891fe2" => :high_sierra
    sha256 "bf68526ad17bed7a7d0c72b29862ccdae97adda5c660acb72745cb71d55213bc" => :sierra
    sha256 "687ef6fcc186936acfe9e4d186c83175094ecfe231b76fff3eee5054b6217602" => :el_capitan
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
