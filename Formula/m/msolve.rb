class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "92b94775cd5a046de307e2ad0fc576d2631e43fbd0eb7749517a033d7e77ddf4"
  license "GPL-2.0-or-later"
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0359086130450435a2bd758ff509ada8558311d6f5a0ec65c5e047d7dfb4439"
    sha256 cellar: :any,                 arm64_sequoia: "cde7840e1544acdb4a0e23f03b05b9303791d57b7120c15254e6f896a326e0cb"
    sha256 cellar: :any,                 arm64_sonoma:  "946d6b2369fb76d682d06b2f7e54f84c3d074e96b90e0c7e9ba74bd89d06c789"
    sha256 cellar: :any,                 sonoma:        "52b2a984e2081204beb19f2e8c9c918115351a1e6af8f439178082f485498ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d467b521b68bfbb770c0790c3fb5d916412b46fd9293dc40ba4f5ccb3fd7c191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f57615e30390e3a7ff3e3de359a62dc7af0314da8d70467eaf480fed43f297"
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
