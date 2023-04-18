class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://github.com/periscop/cloog"
  url "https://github.com/periscop/cloog/releases/download/cloog-0.20.0/cloog-0.20.0.tar.gz"
  sha256 "835c49951ff57be71dcceb6234d19d2cc22a3a5df84aea0a9d9760d92166fc72"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "31099d80dbf2e419acd64dcb95e1c22e703a55088c8704e77bc91e34dc0e5e59"
    sha256 cellar: :any,                 arm64_monterey: "e6e5952ded447b71b8742c7110512d9afc91b7399a900ec8f7b3317c47731f49"
    sha256 cellar: :any,                 arm64_big_sur:  "7e9717c9f378f51c40282abd7defb978d0a0edd960eb84410f493bd96a27e222"
    sha256 cellar: :any,                 ventura:        "72351d437a0b2e31a7941888fa1aeb946bf268573728fc5de5c7416be2913bfd"
    sha256 cellar: :any,                 monterey:       "7238821fcae5761ac240e91f19287ac119eab3db509b7f1b040ba7f9e5b562ff"
    sha256 cellar: :any,                 big_sur:        "d5e21a7bc40be89004c107f89e49c8dbda04cc1b9fb54e15d4225823562b8b19"
    sha256 cellar: :any,                 catalina:       "52c35562f93176d8f3e5216f5f2867aa857e3f0b8b238eb036dea9dbc077595e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b700274e30904d1827d5ec5eacd0809b13183ca532305437a15592dc61167bc0"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Avoid doc build.
    ENV["ac_cv_prog_TEXI2DVI"] = ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cloog").write <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    assert_match %r{Generated from #{testpath}/test.cloog by CLooG},
                 shell_output("#{bin}/cloog #{testpath}/test.cloog")
  end
end
