class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v5.0.2/form-5.0.2.tar.gz"
  sha256 "90a3fbc31a31de50a181e63ce222d0224642a5916fdbb25373913558a6d6921a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "91a588458025f662e3d469bcdeb1ca00af618bec583793225cf930cf031990c9"
    sha256 cellar: :any, arm64_tahoe:       "1c2d7cfa2efa9ac28d44008f71d4986657a005111bc9d7e133d7bda36e4e5f6b"
    sha256 cellar: :any, arm64_sequoia:     "243cd6d28cff1929fd5dcef809dbdf352422bd9cd89ec54a4a7430ac01f9af70"
    sha256 cellar: :any, arm64_linux:       "34a6d153868d8187ce3600a15bbb3ffc7cbf9e73496d177ffb347f3d225c8fa3"
    sha256 cellar: :any, x86_64_linux:      "d7f56f73162c63f91e725f35d11d69c0910edce32c9b99af2cfc310159c3a276"
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
