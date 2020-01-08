class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz"
  sha256 "f3ae8d3d4564a41b6e2a21f237d2f2b104f48108591e8b83497500182a3ab3a4"

  bottle do
    rebuild 3
    sha256 "98a293e2d83134c9a1c35026f68207d9fc2ac1bde9d7d15dd29849d7d9c5b237" => :catalina
    sha256 "b3d7d7bd0bfcada7fc2bc2340ab67362e5087e53b4d611d84aafedf713bde6c3" => :mojave
    sha256 "99646196c8b9e6d5a7b67ecca1589160749d690128bb89aace3b79d4c355dfde" => :high_sierra
    sha256 "5a1c466a3f833797710464dd1aaf4ad6c9ff0a47de33ab3b2ba9cf0c2be36bfd" => :sierra
    sha256 "532c3f14debcd59028285dad1d6fe41dbad481718cc1752b1b9e7c05fd82e27f" => :el_capitan
  end

  pour_bottle? do
    reason "The bottle needs to be installed into /usr/local."
    # https://github.com/Homebrew/brew/issues/2005
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  # Software was last updated in 2007.
  # https://svn.macports.org/ticket/20867
  # https://trac.macports.org/ticket/18255
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0ae366e6/a2ps/patch-contrib_sample_Makefile.in"
    sha256 "5a34c101feb00cf52199a28b1ea1bca83608cf0a1cb123e6af2d3d8992c6011f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0ae366e6/a2ps/patch-lib__xstrrpl.c"
    sha256 "89fa3c95c329ec326e2e76493471a7a974c673792725059ef121e6f9efb05bf4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
