class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.23.1.tar.bz2"
  sha256 "9bc164d0863d41201bd253a2652dcee5806a9c6a8b5918bb8ba09fcee6d7e9be"

  bottle do
    sha256 "3a855680fc84154b2501d53dbb7a4e35b979c653bfa634cbb46b619140977a0f" => :high_sierra
    sha256 "81d589730ed0bad7ba32eaf37886b411f61380322d186633fdc039a82ce1bb1b" => :sierra
    sha256 "3662d978ff61df130e1d904d8707f35a4b6c7ce2f05a8dae29cf106ab4171ed5" => :el_capitan
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
