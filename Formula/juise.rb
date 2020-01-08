class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.8.0/juise-0.8.0.tar.gz"
  sha256 "eea1f6da0f24f6d86abd083bd193b953870fbfc8dab5d11e2a125c2f3ea1c83a"
  revision 1

  bottle do
    sha256 "9858429b5a56e0ac0d5ed35e84c06d334252403d017b768ad585e4a6b6fd869b" => :catalina
    sha256 "022848ff83dab742bbc0c219638a176cb81393861307d48a665a16c2e6d8730a" => :mojave
    sha256 "a1f88b9f9f013eb751d3afcb3a681ff6a0996c818b38ab062e20adb083f7dc2f" => :high_sierra
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
