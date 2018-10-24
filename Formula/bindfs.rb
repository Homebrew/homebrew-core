class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.13.9.tar.gz"
  sha256 "acfa2ca9d604f4147c42758ccbb4a429855df26768dfe70521ba5d7a0596f8b5"

  bottle do
    cellar :any
    sha256 "9fa87b94c367fcd69ac713eb058269eaafde50ada3e32b2a910087b769f31932" => :mojave
    sha256 "7af619973ac822cd21215f60f29b8468f61b6104158830e172be8231e773b05c" => :high_sierra
    sha256 "89f82a2b44e1b8861c917e9f5a3479edc0136ba20a48fe5e1b7597514219b5e5" => :sierra
    sha256 "be32d6c5fd45382418c52c28ee9722486d71b23cb8dffa42ecf1179442518c0f" => :el_capitan
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
