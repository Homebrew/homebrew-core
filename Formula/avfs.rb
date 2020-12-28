class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.3/avfs-1.1.3.tar.bz2"
  sha256 "4f4ec1e8c0d5da94949e3dab7500ee29fa3e0dda723daf8e7d60e5f3ce4450df"

  bottle do
    sha256 "6f496a30b6bd1c8eba1005e4bc0da26b53353effab3f447cf8d43a669ad7a6b5" => :catalina
    sha256 "1e75ce4753a0d9a9af12e4a718537a9e2398fd535413b72505dd126a33610fe6" => :mojave
    sha256 "690fbe0161f0c5ce4ec737e67624b54bfcd7825efa8b554e1773691365dcd6ed" => :high_sierra
  end

  deprecate! date: "2020-11-10", because: "requires FUSE"

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
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
