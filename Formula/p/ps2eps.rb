class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://github.com/roland-bless/ps2eps"
  url "https://github.com/roland-bless/ps2eps/archive/refs/tags/v1.72.tar.gz"
  sha256 "03bd71d8f1cc86369ec865486e8d371f3bd9a3741e86c9f0780797b9ab0a3fd4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e614f533ddb0aebccbd70e89a4fee6a93720896dea44ea06495ff4d91525426"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23f0a910cf3c5b530be5011b50666016d7d5cb27285355d46063442b6e98af34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5152b64948cc7677eb73600d2273b89d056786e6479483dcc00fc1ecb71aa3ee"
    sha256 cellar: :any,                 arm64_linux:       "780aa02d4c08cfaaf5c82e5d8771b7a15d8d5f2ba2667c63abf0b95d66894220"
    sha256 cellar: :any,                 x86_64_linux:      "c982b8dc27a5fc60f3908ca8710e077e3700105e01ad7a4b541a8b16bc4516e8"
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "src/perl/ps2eps"
    (bin/"ps2eps").write <<~SH
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps "$@"
    SH
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*.pdf", "doc/*.html"]
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_path_exists testpath/"test.eps"
  end
end
