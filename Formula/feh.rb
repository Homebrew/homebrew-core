class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.1.3.tar.bz2"
  sha256 "9fe840fbc6ce66dcf1e99296c90eb6fc44a4c2fad9a1069dfc7e0fad88eb56ef"

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
