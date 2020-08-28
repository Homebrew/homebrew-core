class Lesstif < Formula
  desc "Open source implementation of OSF/Motif"
  homepage "https://lesstif.sourceforge.io"
  url "https://downloads.sourceforge.net/project/lesstif/lesstif/0.95.2/lesstif-0.95.2.tar.bz2"
  sha256 "eb4aa38858c29a4a3bcf605cfe7d91ca41f4522d78d770f69721e6e3a4ecf7e3"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 2
    sha256 "c38e2d072aeade356f5bab6e974fbbeb910259c1fe9d2ed8c352f7b67ca5bd0c" => :catalina
    sha256 "a7b26f9ad83bbca9c88de347bc96c616eee9c6d5f0a68caca19b4cffa1347def" => :mojave
    sha256 "bb253ab1835a89928a7c9edb904416b75876cedd50f62647e2d6044fcb55f4f4" => :high_sierra
  end

  depends_on "freetype"
  depends_on :x11

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
      The man page for Core.3 has been renamed to LessTifCore.3 to 
      avoid conflicts with CORE.3 from Perl in case-insensitive file 
      systems. Please use "man LessTifCore" instead.
    EOS
  end
end
