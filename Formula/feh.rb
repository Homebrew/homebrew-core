class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.23.1.tar.bz2"
  sha256 "9bc164d0863d41201bd253a2652dcee5806a9c6a8b5918bb8ba09fcee6d7e9be"

  bottle do
    sha256 "e5dae1c3f9ccbcaa1f531320d8ce731b305794246accc352ed54e58771c18ed9" => :high_sierra
    sha256 "e79da7891f5fcaf66cac98bbf9aa2c4d082dd3491d9e64fbca0afceff186cb2c" => :sierra
    sha256 "9c6ecf778acbfbd1accd3b720366c52553c1284d79a90d720742d343bd349730" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = []
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
