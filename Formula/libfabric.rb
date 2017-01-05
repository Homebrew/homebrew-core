class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  head "https://github.com/ofiwg/libfabric.git"

  stable do
    url "https://github.com/ofiwg/libfabric/releases/download/v1.4.0/libfabric-1.4.0.tar.bz2"
    sha256 "e9f449a137d2f1713ffc970f80a9a8c1fd2970f74f1d118941eafd4b2021bc94"

    # Upstream commit from 19 Nov 2016 "core: remove use of clock_gettime(3)"
    patch do
      url "https://github.com/ofiwg/libfabric/commit/0b0c889.patch"
      sha256 "9ed89d80a2edccc84d157e7fa41159e461e8ebefd717db99123b2323df9ae0aa"
    end
  end

  bottle do
    sha256 "53984f1dac904f22ac42ac6855a1ab61ff0433ac42b499048b47a2ddd66da9bc" => :el_capitan
    sha256 "5828c0555c4d12ab148c26c91859bd389b9bba030114256fb9337118902283c9" => :yosemite
    sha256 "2a3136934b1099fb3288e4283bab1ec2972eb002539e35620dc40d0a00c956bf" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
