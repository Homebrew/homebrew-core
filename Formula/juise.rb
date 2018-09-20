class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.8.0/juise-0.8.0.tar.gz"
  sha256 "eea1f6da0f24f6d86abd083bd193b953870fbfc8dab5d11e2a125c2f3ea1c83a"

  bottle do
    sha256 "6b84ff3cc80b40a549842b1d2cf8f693fb660a0d7acad75e4c8a49903dc81955" => :mojave
    sha256 "5a19782f9698e150c163163697f2252401d9056e264790d8c5b346c5ad04d8b2" => :high_sierra
    sha256 "5fad744e6dea03435e27a673e2652160dd7c5e9543993454f1df57f1132c4ebf" => :sierra
    sha256 "cdb84f723d8178bcebdf8d29161c18b4fd847c18e98c50bdab62981afb22df4c" => :el_capitan
    sha256 "a45ee7ce8991f0ec54d22c7be9d101d835f12465038ab0451824f123a2b644d7" => :yosemite
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
