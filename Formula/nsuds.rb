class Nsuds < Formula
  desc "Ncurses Sudoku system"
  homepage "https://nsuds.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsuds/nsuds/nsuds-0.7B/nsuds-0.7B.tar.gz"
  sha256 "6d9b3e53f3cf45e9aa29f742f6a3f7bc83a1290099a62d9b8ba421879076926e"

  bottle do
    sha256 "60d318290bb60415eb4abfdd7ffad468a24294892ac4ff90895cc0e589ea3da6" => :mojave
    sha256 "26e82eae22288d51eda3742c0ae4f3e1b0b17a003461f1baec38ccaa52495d9f" => :high_sierra
    sha256 "89ae2f310d8b21d98ababce7110f20d3d41da06b7a751447c56aa6dbd13a1950" => :sierra
    sha256 "596fc55d7e2cc63e8fdc4f3648a23d2c3c9c9eee9775a6579410c28708c0a358" => :el_capitan
    sha256 "9bc60ceced759f079112d97d9fc0a408fbe6d7d18d21d3cdcf5a3a2cbf2185cc" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/nsuds/code.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/Makefile", /chgrp .*/, ""
    system "make", "install"
  end

  test do
    assert_match /nsuds version #{version}$/, shell_output("#{bin}/nsuds -v")
  end
end
