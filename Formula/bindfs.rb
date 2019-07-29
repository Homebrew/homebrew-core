class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.1.tar.gz"
  sha256 "b47fcd70fc63b6c72dd4a27ba173d0ca199102c00fe292736d71f44bd4223184"

  bottle do
    cellar :any
    sha256 "f507a7ef8c0c9ee16cbc1004114957400661fcebfe8a2791bf9d95f1debd4070" => :mojave
    sha256 "f53db9e708f483ac30cf2ba9199433feb53f3fe8aa466e1dbc715860256be5bc" => :high_sierra
    sha256 "4baf7170fce17625500d6cb8ef65448de3baeaf70a17946733f567182d725c29" => :sierra
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
