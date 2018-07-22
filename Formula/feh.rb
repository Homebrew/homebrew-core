class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.27.1.tar.bz2"
  sha256 "6ec338f80c3f4c30d715f44780f1a09ebfbb99e92a1bb43316428744a839f383"

  bottle do
    sha256 "8689ee79c3b0a6ccf1686a28d99645c8efd746d9851a797ff924216e2f32e422" => :high_sierra
    sha256 "9641692d5e6f91485e93ce3f6806ede1ef712c831df1d64e57d511c298545672" => :sierra
    sha256 "f6e54c8feb1a2151cf62ba17bb44730df7d2486482d4f3063a673b04f8e5e5aa" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = ["verscmp=0"]
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
