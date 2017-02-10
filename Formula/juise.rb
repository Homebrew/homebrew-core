class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.7.3/juise-0.7.3.tar.gz"
  sha256 "f16fbedc31ce9efd4b0d7aeed2305fdbe8efe1b3c039be5f3b0a2d6014d3fe32"

  bottle do
    sha256 "e6471f194bb00840083cbf692fb4e726edd88982b937e3a41dbbb3c95d5fe665" => :sierra
    sha256 "fc1e16d6035e93e4a13aa2eddb37d5588ee51095705a0f13470bd8a3c68e1ada" => :el_capitan
    sha256 "c0efb90b6a493eb7ca92844378f560da1d11043e2a9c20f58309892613e2baeb" => :yosemite
    sha256 "9fee9246ca23f5928cc5e8fd1d4feb77ce45ca31c8ce93385eb611976c63481b" => :mavericks
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
