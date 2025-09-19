class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "65e5108fa9ef0628c57c3d74737b27582f8deb49a716fbec39d40f4faeb76d4f"
  license "GPL-2.0-or-later"
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "142e6ffe95481d7ea910f62df3157003cd27655315caaccf498aa8a5a141687e"
    sha256 cellar: :any,                 arm64_sequoia: "87deed01325452ff8112bffcbc813e97f40ef7012dd881225dd7f9ea23c11517"
    sha256 cellar: :any,                 arm64_sonoma:  "d38249ea89009fa36fb02b28ec9e68d86a41a33c7b8d375f6c5eb592021b7eb0"
    sha256 cellar: :any,                 arm64_ventura: "d7102d0b4480a354fc9dc60b7095c63778ec6ab82793a60c1c54cf8e0b5cbd6e"
    sha256 cellar: :any,                 sonoma:        "afce84f0d6271e1ec5e51819e53afc9f4412546f685be5bba6cc65dec12d220f"
    sha256 cellar: :any,                 ventura:       "71c1c62f425bbbb55e21c642f613517199ba6d01e18ecca71afbd6242006b8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b4c1588216ee095acad912233b8a75614b162d59d4ef60e268b40d6c52b19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5571e9c3baab37dd681884ef58252b440deccc003be7b730cbbb29c44ae0262d"
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
