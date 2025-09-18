class Form < Formula
  desc "Symbolic manipulation system"
  homepage "https://www.nikhef.nl/~form/"
  url "https://github.com/form-dev/form/releases/download/v4.3.1/form-4.3.1.tar.gz"
  sha256 "f1f512dc34fe9bbd6b19f2dfef05fcb9912dfb43c8368a75b796ec472ee8bbce"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "68c5aae18792314ad080873826f587a7648e493621d5723cae8c45c7bb330bf5"
    sha256 cellar: :any,                 arm64_sequoia:  "891f2e2731329a342dcbda8da08939d5ef910a1bedfaab2be34da51c1f6fe72d"
    sha256 cellar: :any,                 arm64_sonoma:   "9ebf608d1d098eac5b6b0ed04117538f42719ac61db8b7bc06a40aca73d62fab"
    sha256 cellar: :any,                 arm64_ventura:  "9db94c3342b5744b787f9950b3b5931f2b4a1d55daad02352d3daffde5d6b376"
    sha256 cellar: :any,                 arm64_monterey: "ddfd7b8d84cc991ca0ccaea83bab5135535d5a4d96f4daca1dce9b89b18f7992"
    sha256 cellar: :any,                 arm64_big_sur:  "e30e69e4931094eafe38a8c2d25966b86f0df3a8aacffe5480cf0098b84d97c9"
    sha256 cellar: :any,                 sonoma:         "73d42177eaa7cc3546234363beebd1aee8011333ea798cc8020fc65e79bb5824"
    sha256 cellar: :any,                 ventura:        "fc08ffd719328fbd615fc269e7a0a70ed51b1d365abdbd336361ab3645a90d63"
    sha256 cellar: :any,                 monterey:       "4e4183cd34e538a43a6cfcb99ef054ab75786e40088806aed7d61a54950869e5"
    sha256 cellar: :any,                 big_sur:        "62ddb0717b667323815d8a35c6377bb479be7ebe6ceb5e331d341191d6cb0e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "97d17131f6de2b0dff19e8777cf5e26148e0b713c6e6ea2ad66bb740ed8ca5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bdafe12587a3d4a8f64c28024b01ba0137e81ae5ceab40c865614544c66eb89"
  end

  depends_on "gmp"

  uses_from_macos "zlib"

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
