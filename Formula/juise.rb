class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.7.3/juise-0.7.3.tar.gz"
  sha256 "f16fbedc31ce9efd4b0d7aeed2305fdbe8efe1b3c039be5f3b0a2d6014d3fe32"

  bottle do
    sha256 "f06626a7a780aa3a611f824379ea4ccc8aa9d86dd60eb3a9ea57b2adc502d2cb" => :sierra
    sha256 "d8ba0fc9fa29cfe00fec87c88ca5745a0da3109beab94da9ecf1ac4a7632e55e" => :el_capitan
    sha256 "c0b82fdd6ebca18deb01481ec5dd0cd3f349994441445afdae2f71606766a69c" => :yosemite
  end

  head do
    url "https://github.com/Juniper/juise.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "libslax"

  def install
    system "sh", "./bin/setup.sh" if build.head?

    # Prevent sandbox violation where juise's `make install` tries to
    # write to "/usr/local/Cellar/libslax/0.20.1/lib/slax/extensions"
    # Reported 5th May 2016: https://github.com/Juniper/juise/issues/34
    inreplace "configure",
      "SLAX_EXTDIR=\"`$SLAX_CONFIG --extdir | head -1`\"",
      "SLAX_EXTDIR=\"#{lib}/slax/extensions\""

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    assert_equal "libjuice version #{version}", shell_output("#{bin}/juise -V").lines.first.chomp
  end
end
