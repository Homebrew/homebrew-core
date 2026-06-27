class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v5.0.1/form-5.0.1.tar.gz"
  sha256 "ce62530a54e5232dfefb6c1ff0e7047372a43941b3c0e0db08b5714fd868722c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3cca001e2ef23bf212d8b0267453ea487480826e0271b660c641195e229a2e95"
    sha256 cellar: :any, arm64_sequoia: "bde3419da164d5e129d122c6598f9aa340e2e3cd09fc9408db0f06797bf34a1c"
    sha256 cellar: :any, arm64_sonoma:  "0e1f47450dac96ef23c1e46c9de972641c04666895b51bd3f1c4f4cb4d8e9551"
    sha256 cellar: :any, sonoma:        "4d1e107895bfe029c0951e87d029570ceb4352bc352b73d27466a59cef73ec8f"
    sha256 cellar: :any, arm64_linux:   "2a33cf375f46c341eff2000abc284a66ae1b701be6116df6b9484c0ee2e19045"
    sha256 cellar: :any, x86_64_linux:  "87fa4e0ed548f5507d07f6da45354aee8833b6ff89a585a5cc5fcd14a0018396"
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
