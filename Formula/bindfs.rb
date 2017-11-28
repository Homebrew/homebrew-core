class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.13.8.tar.gz"
  sha256 "7e7fcf070345d8cbb45186384e0aaf3e3a6375031d7a4f9533dd5d784c32c358"

  bottle do
    cellar :any
    sha256 "ec6a8af7ad9f59d12311781d34f0f9b03bf261bcf1d70e053b6a173cb6b1777f" => :high_sierra
    sha256 "e5b418a99136e9360000fecea2546774a1e101d2d559ccde7c0c5da1a216e235" => :sierra
    sha256 "964698c965bf549db65bc9f9a41c244e515f90639bd753fa40b44f34615aede8" => :el_capitan
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
