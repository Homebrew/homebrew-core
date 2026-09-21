class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-710.tar.gz"
  sha256 "d1008fb78dcae1323ddab664bcb352a61f022b1b131bd8018548e021d975ec7a"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4424cbf3a1ce87d36b39ab1918bb5d871289f1e6e33a012bd9483f16fb4b82a2"
    sha256 arm64_tahoe:       "4a25aee751a4c5a12886744cbaedd6d60ab039989f764f2e74591567097ebd55"
    sha256 arm64_sequoia:     "1059c6f2cab177f99362517f59e249bd9fa33e8c417056c5acde2804f4861870"
    sha256 arm64_linux:       "c2c82e6f10e8ece95d96a020bfdcb08d87775a1db4ea487a8b57a73867f700ad"
    sha256 x86_64_linux:      "bbc93622a13a6aeae4640938a4fab6f5298d255c1f352b433ff288db2bb68cc5"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  deny_network_access!

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello, Homebrew!\n"
    assert_equal "Hello, Homebrew!\n", shell_output("#{bin}/less test.txt")
  end
end
