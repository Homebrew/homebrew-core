class Lesstif < Formula
  desc "Open source implementation of OSF/Motif"
  homepage "https://lesstif.sourceforge.io"
  url "https://downloads.sourceforge.net/project/lesstif/lesstif/0.95.2/lesstif-0.95.2.tar.bz2"
  sha256 "eb4aa38858c29a4a3bcf605cfe7d91ca41f4522d78d770f69721e6e3a4ecf7e3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "b21ba8ea2bfc016141ab76a3021c7a941f1a682840cec111bc2bc2b8adc53af6"
    sha256 big_sur:       "49ec8eeeb266caef90b7fee6151d7292e4b636256863a9a4b67abdf965aba33b"
    sha256 catalina:      "78f251801b6befbfc5823a668c45babcec2f24a0de4befd089f1034e02dcbf46"
    sha256 mojave:        "f522a309507b2f9c2aad4aea7a8bbb6cc7d845e922d6d49cd3ca81bccad7f5f5"
    sha256 high_sierra:   "6bc0a2511a83a9a15bc27a2385aa7fd944836eb4e685ee7878e590be7680e713"
    sha256 x86_64_linux:  "4472bebd72a9ed03121c7cd4c9d2ef99c1da329ebfce7d41a0cf7240ed12cbeb"
  end

  disable! date: "2022-07-31", because: :unmaintained

  depends_on "freetype"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxt"

  conflicts_with "openmotif",
    because: "both Lesstif and Openmotif are complete replacements for each other"

  def install
    # LessTif does naughty, naughty, things by assuming we want autoconf macros
    # to live in wherever `aclocal --print-ac-dir` says they should.
    # Shame on you LessTif! *wags finger*
    inreplace "configure", "`aclocal --print-ac-dir`", "#{share}/aclocal"

    # 'sed' fails if LANG=en_US.UTF-8 as is often the case on Macs.
    # The configure script finds our superenv sed wrapper, sets SED,
    # but then doesn't use that variable.
    ENV["LANG"] = "C"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-production",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static"

    system "make"

    # LessTif won't install in parallel 'cause several parts of the Makefile will
    # try to make the same directory and `mkdir` will fail.
    ENV.deparallelize
    system "make", "install"

    # LessTif ships Core.3, which causes a conflict with CORE.3 from
    # Perl in case-insensitive file systems. Rename it to LessTifCore.3
    # to avoid this problem.
    mv man3/"Core.3", man3/"LessTifCore.3"
  end

  def caveats
    <<~EOS
      The manpage was renamed to avoid a conflict with Perl. To read it, run:
        man LessTifCore
    EOS
  end
end
