class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.7.tar.gz"
  sha256 "2826e7c01928c9c260e7d1fc20ce8e820432b2de1a0f0c6c0193bdbb13f378d1"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "1b6004bba2060be73c1bb139ce3ebd5edf33fbb542a91672b5e98ac149126775" => :catalina
    sha256 "eba7a033496208341d5ce0fb59e3871cbb7503b7d2f6c73922bb9764f539b3b2" => :mojave
    sha256 "b18a684fe8e4bff83e37e1a36eefd66ea24e1a8ebf31bcc2f0c3c5b7e4348402" => :high_sierra
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
