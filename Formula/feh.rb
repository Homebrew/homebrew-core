class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.18.1.tar.bz2"
  sha256 "4c3840285eaf7ad474547d12870430d0392efdce4cf897666aa1ab02612e65b2"

  bottle do
    sha256 "c22edfd8e61da97c2f63cceb67a4452a98fe4a75aef65fc2b396ce83f9285998" => :sierra
    sha256 "10b1b52be19171334116dfcab3384e180c10109891ee64c0536718fb2b870fe6" => :el_capitan
    sha256 "668a4a8795060259d0e87e5de1180b2301441168da58ee93467459d47bdb3b78" => :yosemite
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
