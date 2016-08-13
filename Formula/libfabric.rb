class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.3.0/libfabric-1.3.0.tar.bz2"
  sha256 "0a0d4f1a0d178d80ec336763a0fd371ade97199d6f1e884ef8f0e6bc99f258c9"

  bottle do
    sha256 "53984f1dac904f22ac42ac6855a1ab61ff0433ac42b499048b47a2ddd66da9bc" => :el_capitan
    sha256 "5828c0555c4d12ab148c26c91859bd389b9bba030114256fb9337118902283c9" => :yosemite
    sha256 "2a3136934b1099fb3288e4283bab1ec2972eb002539e35620dc40d0a00c956bf" => :mavericks
  end

  head do
    url "https://github.com/ofiwg/libfabric.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
