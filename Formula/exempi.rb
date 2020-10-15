class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.2.tar.bz2"
  sha256 "52f54314aefd45945d47a6ecf4bd21f362e6467fa5d0538b0d45a06bc6eaaed5"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "3ef58fd5cbd177ac785cfab9b58f813ce24320a507243d9d7b6c940fd463564f" => :catalina
    sha256 "189bb3c57e78845c33678353cb877ad7cdedd665087c0a4525397f32088abc39" => :mojave
    sha256 "0843f9bc589fd3c9ed0f5dfd724ba60eea4832410a0b6ff831bdb22c6563eafd" => :high_sierra
  end

  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
