class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    rebuild 4
    sha256 "540ccb96d3647a0d71f563e06d08e410d14b7d09c23f6348bc91fd22251e5ff2" => :mojave
    sha256 "ece250e6792f542e5546ac5e8e5144fe07c76ce3ddb94216181e85092d530e81" => :high_sierra
    sha256 "bb550ef762ca5d65f87b65575758557afcf8e6b93855be32638cab265540ba6b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
