class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.9.0/juise-0.9.0.tar.gz"
  sha256 "7eb7985944b7322fe290f4e5a080a4018ed84bf576e23b8a32e3f94eb13f4c27"

  bottle do
    sha256 "fdc8151a4937275308e7d353b0f42007e5a371a58551c2609351ac9ae0647bbb" => :catalina
    sha256 "7895026372337e9a86c906b364f5a3bda3c217e6def31b6e51ada8ab14c9334b" => :mojave
    sha256 "6c4e884c63521014cd059e59372130ea70a06067769aaaf79497cb1f6877c41a" => :high_sierra
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
