class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.2.tar.gz"
  sha256 "698c8d02b4e77a71e52184bd66869f4d63add4411e76636ee045d154b374c57e"

  bottle do
    cellar :any
    sha256 "9ab13b9d34fa7b435f949c35fea8a685f2802c1ea958d8e74c16ad3dff7286b5" => :catalina
    sha256 "1e061f3092a6cb781432f80b2b70f245a7ffcd30c3c75bf7c4235065c17d12ac" => :mojave
    sha256 "0dc8db4676655204f096e427c1424e1a24939fceabf62c7623dc6d0d5a8c28cc" => :high_sierra
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
