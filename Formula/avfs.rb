class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.0/avfs-1.1.0.tar.bz2"
  sha256 "a7f3734f5be1a76aab710fb49a004b60bb802ccbd32394a731b18ed6011333a7"

  bottle do
    sha256 "f7b1f3a2a166a4418f6f27707dae144391f6ee2db5fe6029a2369d8de6d2093d" => :mojave
    sha256 "782ac0bc73deff3843c7af2b05e4b82cd99c8062c41014100ca1b2d56a5f5b53" => :high_sierra
    sha256 "810afba90280d2aaef31560b9d0776cce882fc549e9c0575ba9777bd626687b7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "openssl"
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
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
