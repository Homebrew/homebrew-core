class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v5.0.0/form-5.0.0.tar.gz"
  sha256 "10d22acf2f0acf831b494e6a73682828980b9054ea8ec2b5dc46677dca8d6518"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c7f21024418e6cfa0e6dd9915e4ac38566cb583e9acf0df3d1994393abb91f43"
    sha256 cellar: :any,                 arm64_sequoia: "33d30949b241289875fba956536d17180c56a377c56181100b04efd87c5832cf"
    sha256 cellar: :any,                 arm64_sonoma:  "6d9766a69f1b07bb9562f5be2ea4ef6f1f51ac859751c1b9ac145bbb05bcd4c5"
    sha256 cellar: :any,                 sonoma:        "affb7cf3d41487583b89a94296ae4fa6431d9d3e28e4868463898e94317dd8a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552e5c787b81c28ff3a2c7ff80dfaa191b713fb1fa19eb95ad4ed24315389717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa27050572d29b865752d49abdd41a501b16bedb244d2a05f4b530eb35c27f05"
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
