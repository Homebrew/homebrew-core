class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.1/avfs-1.1.1.tar.bz2"
  sha256 "c83eef7f8676db6fed0a18373c433e0ff55af1651246303ebe1181e8ef8bbf3b"
  revision 1

  bottle do
    sha256 "e9f048f1f3f156b62c0650d07b51e82020a896538a51fdffd2ae06bf2d661380" => :mojave
    sha256 "4ca7d845c2b2e3c066c2441490b7e9588ef727ab0815aee57c5321ad826435df" => :high_sierra
    sha256 "9dd4c35adcc1c1350b48f0a37130414370b38c63a886a0b1824838da34a16c97" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "openssl@1.1"
  depends_on :osxfuse
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
