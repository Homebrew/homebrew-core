class Nsuds < Formula
  desc "Ncurses Sudoku system"
  homepage "https://nsuds.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsuds/nsuds/nsuds-0.7B/nsuds-0.7B.tar.gz"
  sha256 "6d9b3e53f3cf45e9aa29f742f6a3f7bc83a1290099a62d9b8ba421879076926e"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/nsuds[._-]v?(\d+(?:\.\d+)+[A-Z]?)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "983aff6a207bb1a4224ca713567000ccb578b108d6c358982654e2fcd59313d9"
    sha256 big_sur:       "17ff896355ee4f8905783422f8e1dbb68b88d45ba1ca6cc46116c93ec35bc2ef"
    sha256 catalina:      "dcccae0ffd504a9a09ed57bfe0ac26127723c92513177eb862fa132e21c6968a"
    sha256 mojave:        "60d318290bb60415eb4abfdd7ffad468a24294892ac4ff90895cc0e589ea3da6"
    sha256 high_sierra:   "26e82eae22288d51eda3742c0ae4f3e1b0b17a003461f1baec38ccaa52495d9f"
    sha256 sierra:        "89ae2f310d8b21d98ababce7110f20d3d41da06b7a751447c56aa6dbd13a1950"
    sha256 el_capitan:    "596fc55d7e2cc63e8fdc4f3648a23d2c3c9c9eee9775a6579410c28708c0a358"
    sha256 yosemite:      "9bc60ceced759f079112d97d9fc0a408fbe6d7d18d21d3cdcf5a3a2cbf2185cc"
  end

  head do
    url "https://git.code.sf.net/p/nsuds/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    ENV["LDADD"] = "-lncurses -lm" unless OS.mac?
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/Makefile", /chgrp .*/, ""
    system "make", "install"
  end

  test do
    assert_match(/nsuds version #{version}$/, shell_output("#{bin}/nsuds -v"))
  end
end
