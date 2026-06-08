class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v5.0.0/form-5.0.0.tar.gz"
  sha256 "10d22acf2f0acf831b494e6a73682828980b9054ea8ec2b5dc46677dca8d6518"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8b52733af783cf3c6e22373eae30f3aa9d036d8309b71048ef8932a84c65c31"
    sha256 cellar: :any,                 arm64_sequoia: "946e4effaa86c76d0ce562d4a58340a1bea5fe3b0bb767e4f3dc992a63ab4ff8"
    sha256 cellar: :any,                 arm64_sonoma:  "fa434b6485ceb5ce3d2e831225b0709070b7616f45d40d3fd6395da397867b39"
    sha256 cellar: :any,                 sonoma:        "ec045556f3270e4eb3ade5975450976c25f81d7227a5166e8b07f4a6817fd4a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be93cd028152d809ba05ca09a0c9f38e107c00f0e0d2d27e759b117e0098ece9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015e675b0c42ff0b774e45f0ce7d335a436885c133a7842d78968553e27b0bfd"
  end

  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-native"
    system "make", "install"
  end

  test do
    (testpath/"test.frm").write <<~EOS
      Symbol x,n;
      Local E = x^10;

      repeat id x^n?{>1} = x^(n-1) + x^(n-2);

      Print;
      .end
    EOS

    expected_match = /E\s*=\s*34 \+ 55\*x;/
    assert_match expected_match, shell_output("#{bin}/form #{testpath}/test.frm")
    assert_match expected_match, shell_output("#{bin}/tform #{testpath}/test.frm")
  end
end
