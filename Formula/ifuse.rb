class Ifuse < Formula
  desc "FUSE module for iPhone and iPod Touch devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz"
  sha256 "9b63afa6f2182da9e8c04b9e5a25c509f16f96f5439a271413956ecb67143089"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    cellar :any
    sha256 "6b0dc5b7eec5838f20855593340bcca01193502d5f32fc2bf11c6e39bca551ae" => :mojave
    sha256 "d19076c990140bc4dbbcdfa75182c0be880d57fdf418b3c1c1780f53fd8adac9" => :high_sierra
    sha256 "424c1d3dcc232ca0afa729bc27abcc4d5519e879ea61badfd3fb4e9d1ff3af1b" => :sierra
    sha256 "2225777c6c9afaa0218f0fa8ca6b8eb0bc0a34ab7004e48613ff51af63f64d02" => :el_capitan
    sha256 "9ea6fd7a09dbfba5bb1f1a7335330977440c1e3d73dac29b8a6433a6a35d1bff" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
