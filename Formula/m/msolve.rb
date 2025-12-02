class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "9ba8b290fee048e49615015c43a7a1f2c05ac7e7fb277a964105d51c082f7d9f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "252518043e7f1859ea067c0881162a1fe4981a0e83a38dd85bb04dd642a5e57d"
    sha256 cellar: :any,                 arm64_sequoia: "4858884355f5e2b67de7f1d048be9f516fc7f6a427b436121065ca0a527eede6"
    sha256 cellar: :any,                 arm64_sonoma:  "b9ede5e32d42702ff01b890a0b0bae3e9a5f5277116325a4ffff49fda1ca4068"
    sha256 cellar: :any,                 sonoma:        "c76be2f48d23e988f69f2a1ae663f54f5aa2579fc889a5613e11f04bcf5a5013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c370e6b2107304d0815efb4f49f7a558aeb105acae44bd2c612fbc1a814a6b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b40605c4a4b473a2c80cf0acc05904892a38bcec3873fb9daebb61ee59d23e5"
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
