class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.13.7.tar.gz"
  sha256 "09a41b32db5ef54220161a79ffa4721507bc18bf9b3f6fcbbc05f0c661060041"

  bottle do
    cellar :any
    sha256 "8777dbb90778636bdcc29da83ac45799ad14df497db3f6784eead9dfade0f59c" => :sierra
    sha256 "ea5db902b0ec2ffd77e7e9cdbc291a00b56f50148c76ee264da67f4e57b4b7cc" => :el_capitan
    sha256 "22a997934238dee06239fcad12a7c888868c3d80465ede781b314f1ee2a21b34" => :yosemite
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
