class Bs1770gain < Formula
  desc "Loudness scanner compliant with ITU-R BS.1770 and ReplayGain 2.0"
  homepage "https://bs1770gain.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bs1770gain/bs1770gain/0.5.1/bs1770gain-0.5.1.tar.gz"
  sha256 "06749f866417e6bcdb9fb24883cb08ae54248333a532380c7ddc56f7a45a8e64"

  depends_on "ffmpeg"
  depends_on "sox"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bs1770gain", "-h"
  end
end
