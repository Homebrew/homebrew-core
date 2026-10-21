class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0f4e8276cacc26eb6abef47982dcb39a6d98d17c5a20b34488d6fd8676d4822d"
  license "GPL-2.0-or-later"
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6fe1ed9717a909ead0596ccba8505fff926225dcddf9d2a2179178e41305b491"
    sha256 cellar: :any, arm64_tahoe:       "f36c3ed46e78f9eb35cce93cccad181ab2c4979d8a06a126278030d1d3f06447"
    sha256 cellar: :any, arm64_sequoia:     "1ea47a3abadcc8b0a18657dcd90024e13d27a0f8d69a810362f2ac0d211ec6ac"
    sha256 cellar: :any, arm64_linux:       "22d70b346bdf931508b5595cb4b66fda445f61058ef6eeb1989615b79e1dc84a"
    sha256 cellar: :any, x86_64_linux:      "0d61e2c8d39eda667796a8f30eb24c65930422a0ed4ef2f626fdb5be85521f82"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"

  on_macos do
    depends_on "libomp"
  end

  def install
    # avoid unsupported openmp
    if OS.mac?
      libomp = Formula["libomp"]
      ENV.append "CPPFLAGS", "-I#{libomp.opt_include}"
      ENV.append_to_cflags "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-L#{libomp.opt_lib} -lomp"
    end

    # only compile with cpu baseline features for the pre-built binaries
    inreplace "configure.ac", /AX_EXT/, " " if build.bottle?
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--enable-openmp=yes", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"eco10-31.ms").write <<-EOS
      x0,x1,x2,x3,x4,x5,x6,x7,x8,x9
      1073741827
      x0*x1*x9+x1*x2*x9+x2*x3*x9+x3*x4*x9+x4*x5*x9+x5*x6*x9+x6*x7*x9+x7*x8*x9+x0*x9-1,
      x0*x2*x9+x1*x3*x9+x2*x4*x9+x3*x5*x9+x4*x6*x9+x5*x7*x9+x6*x8*x9+x1*x9-2,
      x0*x3*x9+x1*x4*x9+x2*x5*x9+x3*x6*x9+x4*x7*x9+x5*x8*x9+x2*x9-3,
      x0*x4*x9+x1*x5*x9+x2*x6*x9+x3*x7*x9+x4*x8*x9+x3*x9-4,
      x0*x5*x9+x1*x6*x9+x2*x7*x9+x3*x8*x9+x4*x9-5,
      x0*x6*x9+x1*x7*x9+x2*x8*x9+x5*x9-6,
      x0*x7*x9+x1*x8*x9+x6*x9-7,
      x0*x8*x9+x7*x9-8,
      x8*x9-9,
      x0+x1+x2+x3+x4+x5+x6+x7+x8+1
    EOS
    system bin/"msolve", "-f", "eco10-31.ms"
  end
end
