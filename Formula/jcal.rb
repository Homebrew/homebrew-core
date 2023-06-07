class Jcal < Formula
  desc "UNIX-cal-like tool to display Jalali calendar"
  homepage "https://savannah.nongnu.org/projects/jcal/"
  url "https://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz"
  sha256 "e8983ecad029b1007edc98458ad13cd9aa263d4d1cf44a97e0a69ff778900caa"
  license "GPL-3.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/jcal/"
    regex(/href=.*?jcal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "199711a3aa65d8d6b5d7ae804e99f0025ad8eb59c77f37d4058566edc6c0d1eb"
    sha256 cellar: :any,                 arm64_monterey: "6f1986d499d27fd07525390066318239e9efdac990a58578ef3fe2147d32563b"
    sha256 cellar: :any,                 arm64_big_sur:  "6995c49236be96cf2adcf11cd03a88f46436ca66061de24d087c1c69aa4b9f6c"
    sha256 cellar: :any,                 ventura:        "feac90459a79da88e1fc37a090d811e5c76a43cae3f1fc6075c2da8e6a3e3fcb"
    sha256 cellar: :any,                 monterey:       "2ebbf3f00eaedd9e2a539af5eab274bc5a1417cf3e7d44d889272bef86c83a79"
    sha256 cellar: :any,                 big_sur:        "00a9eec192b14b6b4a442e1268bd7727df19923901d36ca225a32e69477df5de"
    sha256 cellar: :any,                 catalina:       "0544ee162b480d5999a312cf721b40007901f964b20edbdd8e062b2e95c64157"
    sha256 cellar: :any,                 mojave:         "4274c678ae3c2110c94b474aa56fcbb6b121645f9a91352b7c24bf028750f3d9"
    sha256 cellar: :any,                 high_sierra:    "348fdd02ce58859bf75ebe00feaf5c90e1f4f052d531e7667343f4c220d8e7bb"
    sha256 cellar: :any,                 sierra:         "d6f50844723751f0de8181f751ffc0912013b518b5ac60777a3ade7e1aaa3179"
    sha256 cellar: :any,                 el_capitan:     "4d876e18cb50c7aa31211b60b66e42637ca3c9eeed9c688c1945dc4755977597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b67ec668f4880126342f70bb106b66744773ebbe8afc9e11eacf96d5a11108"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    shell_name = OS.mac? ? "/bin/sh" : "/bin/bash"
    system shell_name, "autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jcal", "-y"
    system "#{bin}/jdate"
  end
end
