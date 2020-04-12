class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.4.tar.bz2"
  sha256 "18545ca5c7537268810bec564db9cd3ad1ca98c2a2f23ec243d3bac56cfc0365"

  bottle do
    sha256 "5c9a6a77a491ac4bb9dd8bd347c9604c3887d991a69313270e65990c1fe778e2" => :catalina
    sha256 "e3b395fac60062ddb22e25bf150cff78424e69a2345465943ccde406ddbb3273" => :mojave
    sha256 "7fa85c8cada38cb4542092a31f9f6cd9f18d1e3426b48ad7061d3dc1513f60f6" => :high_sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
