class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.13.7.tar.gz"
  sha256 "09a41b32db5ef54220161a79ffa4721507bc18bf9b3f6fcbbc05f0c661060041"

  bottle do
    cellar :any
    sha256 "5a02df3aa055b955433ede6396dd0cd94308efebdc067e76d2295e89b295c600" => :sierra
    sha256 "9b59fb96e86437065a43c58928403851aee9824a1bfaa67a493e30a21b607f8f" => :el_capitan
    sha256 "6854d875a56bfb0a5b95f4a009992199e6a6b53980f6543031903056f4deff93" => :yosemite
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
