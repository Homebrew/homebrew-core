class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage "http://xmailserver.org/libpcl.html"
  url "http://xmailserver.org/pcl-1.12.tar.gz"
  sha256 "e7b30546765011575d54ae6b44f9d52f138f5809221270c815d2478273319e1a"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pcl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "454d1dd0179febc856b1d8b75fe9396e6ae6b695b513523162f9a3fa41d5dc4f"
    sha256 cellar: :any,                 big_sur:      "2ed8a2eb0ff0c53cb2a2653991386ceded74a41a8a215e0d641221092917e361"
    sha256 cellar: :any,                 catalina:     "11984be842d85e685f2e52d4d5155f24123a44e0f1855970c5fed1e8cb2172f5"
    sha256 cellar: :any,                 mojave:       "3eb3bf64576a13da02b76cf21bfd37a9889e48d3e7c0df06bd5767c61cc09d06"
    sha256 cellar: :any,                 high_sierra:  "2d7ce1c2a11e762dacf0e28f92a1b1f6b6a45ea4564ac579b4c0683c61ac61f7"
    sha256 cellar: :any,                 sierra:       "525c0925d7d3234cf5da86a892d15aa4f6d4417f302ed821e2bfd6e7cb06ef43"
    sha256 cellar: :any,                 el_capitan:   "1975baf018352fd1f1ca88bd39fc02db384e2f6be4017976184dda3365c60608"
    sha256 cellar: :any,                 yosemite:     "e9c6f7bc1efab583e44879426a5abb2ff5e7f3eb30261a81a7be723c3280c3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4477cd796405dfbf475dc7f65339aac5bba8fdf4d9027724c479edaf6f3f2553"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
