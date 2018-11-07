class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.28.tar.bz2"
  sha256 "13d22d7c5fe5057612ce3df88857aee89fcab9c8cd6fd4f95a42fe6bf851d3d9"

  bottle do
    sha256 "89f7c4eb397616415e1d3bf4e2b9e1fc101f9beae8edc4076da0e76775423398" => :mojave
    sha256 "f69b4b8f44e56f4a4c147e11bef18c1cf8a6ee7582f72305ff1487ca10a12a06" => :high_sierra
    sha256 "2a4581cdf48afb72a2b2f3e0c1a7f8139af065fd4051bcc89b6ce2102b6797ef" => :sierra
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
