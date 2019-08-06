class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.1.tar.bz2"
  sha256 "100b3d5b1b3370bc2e31c0978991716c4a4478246a2ac2df6382054a0ae89bc8"

  bottle do
    cellar :any
    sha256 "f276793d07a9d9509e3d9e9267a59a22bb95b1a021468e121700d64ec8e5176d" => :mojave
    sha256 "424eaeb7c609a08e98ba614d386d5b19deda7c808606698b398bac710637cfa4" => :high_sierra
    sha256 "b23d8e0ef9d2cefe04a3b1c288a06b0c7cd0202aa05f768f43a499461ea68288" => :sierra
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
