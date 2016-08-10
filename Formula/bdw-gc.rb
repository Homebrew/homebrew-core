class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
  sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"

  bottle do
    sha256 "939e43625f304cc5d315f28147db4323da910e7ade2efddea01fade0c56faf48" => :el_capitan
    sha256 "a49e8aaa7f869a5c7dec0d4e38bb02f6be7e82a45341953f3e761716e3836ef2" => :yosemite
    sha256 "392bb21f15af6c0ea2a9edfe0641362672e9d7ce8d9fee121e6a64e6081f79b0" => :mavericks
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
