class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v5.0.1/form-5.0.1.tar.gz"
  sha256 "ce62530a54e5232dfefb6c1ff0e7047372a43941b3c0e0db08b5714fd868722c"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb75ccd07f0cc125ffd856062ebf74ba0bb19f8acbb02be549c39fc4e3033684"
    sha256 cellar: :any, arm64_sequoia: "f250314c8d59119c18883644a13183bb6f420a79422c900c3884335c9d4e452d"
    sha256 cellar: :any, arm64_sonoma:  "811f978b7138d3982982836fdc271cfce2d3f15f7163d04ee5ed7f0a77ffa2d4"
    sha256 cellar: :any, sonoma:        "45a57f910be5dbb5f6e39cc238d3ed1855fadb36d56fed3a36619c64aee2eb15"
    sha256 cellar: :any, arm64_linux:   "e2b0714d5c30e5b1d2ae552cd87adc64eafc3c860645979f90a2ac6f98e8c602"
    sha256 cellar: :any, x86_64_linux:  "f26e66ad0b1b7644cc4346b7170679be7fb42371031df212a854fcc8c848b588"
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
