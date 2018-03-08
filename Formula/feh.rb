class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.25.1.tar.bz2"
  sha256 "0c5ef21601c11e1aeccb3531a84658c4b67aeb9ab8db92a1da6d8cbad0a9faa4"

  bottle do
    sha256 "b79277f27b31d4307b109cde7b7a7d205afb4bfd2392131b8e3c384e9fffcc20" => :high_sierra
    sha256 "bc261c7ca1385e9ea87ee569dadfe21cd15e59fd4f2491d2338cb447d6ac0847" => :sierra
    sha256 "9b0caf610a74b9ffe126bd63b4d5214cf5c16eaef290a6ca6ca75c5e220810e6" => :el_capitan
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
