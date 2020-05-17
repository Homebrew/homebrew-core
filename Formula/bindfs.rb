class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.7.tar.gz"
  sha256 "2826e7c01928c9c260e7d1fc20ce8e820432b2de1a0f0c6c0193bdbb13f378d1"

  bottle do
    cellar :any
    sha256 "5058a244ccff7948afdd5e2e09c9c9b30f0d1f16d832912312a0e50e1b55bdd8" => :catalina
    sha256 "b7dabe6b50cbfeab3e9d18ea0f29ac55220ac11a2e095b21a0ff0fe857f2e1a0" => :mojave
    sha256 "c6ab23256f69f3296c2a7b49891fabd665911b6f92b5e67c241040e134f76184" => :high_sierra
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
