class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.22.2.tar.bz2"
  sha256 "05a81fbe0997f6274c7617efc351647be38e5244c2624bd203459025c9a68ecd"

  bottle do
    sha256 "ce5bd97807982041096c12e34aafd3ee62e3735c13fa821adaeb74eacdab8733" => :high_sierra
    sha256 "5fd688aed61d555b2c7a8a66796188dab6c14c0b595d073ca54df2c1a2995a51" => :sierra
    sha256 "973869d66ecb40d7de2ab9bdef23e6f1e7640dec67acca0d6ae8a270be133338" => :el_capitan
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
