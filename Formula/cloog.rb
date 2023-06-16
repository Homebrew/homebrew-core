class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://github.com/periscop/cloog"
  url "https://github.com/periscop/cloog/releases/download/cloog-0.21.0/cloog-0.21.0.tar.gz"
  sha256 "7bdd1bcfca1f9157186ea837e9b111bae7a595b24435e63099bac7c6763b376d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "595b6549ffe14d8846d10e3bf9962ebef7dbe3f1f5745b3444d4c3b7e05f76fb"
    sha256 cellar: :any,                 arm64_monterey: "f884aa1f8578a533508676ee3a1bc0db7c59e2a4376d6503e140a9ab87136850"
    sha256 cellar: :any,                 arm64_big_sur:  "2ed6822fd8111355d87859bca2297fd3ad6f0714672a8e419c470f273ef8c05e"
    sha256 cellar: :any,                 ventura:        "5357619a36d333934b8ddce16bad3785b886d9835a9a5524a1ec49e26216a7ed"
    sha256 cellar: :any,                 monterey:       "58a114afff3716a7918da518e4082f8cb8c11a9c988506f20629141e7ecb6d3f"
    sha256 cellar: :any,                 big_sur:        "19c1a6cbd9aa0149cf1e443a99e4cf41f83f6a37f85cda0b737c9203a1a70c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640f2b803875a4b71a3a390b8a852dcbe938016af60e873440a62f986dbaa930"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

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
