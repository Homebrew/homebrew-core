class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://github.com/xiaoyjy/cconv"
  url "https://github.com/xiaoyjy/cconv/archive/v0.6.3.tar.gz"
  sha256 "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84"

  bottle do
    cellar :any
    sha256 "ffaf8b5cab0618e52cfedff14a5084cfe54e0b1b6480433e2ffb4beee8e47ec9" => :mojave
    sha256 "c4d197f979340a89d5a87e05eae6a39db38863f89b6ddda42f924472d87a5b0d" => :high_sierra
    sha256 "2e885b9571a8814f2b23b088f3f0d45f47b1fe762f040c3e66b1a81f84673646" => :sierra
    sha256 "bda78602260276dd3e5187a5a9d6bbcfb95ff40aa513840569e490d5dc96aab2" => :el_capitan
    sha256 "a77d6efc52430482ff2c64db8ba20444b50faf79491c95f8f6bd9f3f29050c53" => :yosemite
    sha256 "e4c46fb9d36be065327eada53be03aa8a83665add22340805ef96d0fa5fdb8d6" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "LDFLAGS", "-liconv"

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    rm_f include/"unicode.h"
  end

  test do
    system bin/"cconv", "-l"
  end
end
