class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://github.com/roland-bless/ps2eps"
  url "https://github.com/roland-bless/ps2eps/archive/refs/tags/v1.70.tar.gz"
  sha256 "cd7064e3787ddb79246d78dc8f76104007a21c2f97280b1bed3e7d273af97945"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "07c8fdeb6cd50b5a03d6cd29b80a45cddb0c40149d3e739ab56d8ac33f0ccd45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0cd7a84b33465e03768eb2c76ec181b730c775f18e57eeb282df636ee1a8e10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09d6e7f0fbbec5bd6e494715028e9730c32ddb1284261d5593734d1bd35c79da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0993f1da048518572c4388a4eab1e7c37151c97859eec0802b639ef803d71eca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdadaaab653031dd42695d12d97e7b831e15d6e823f00abc74a5a2f89a7e4954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb048bafbe5b44a17151bc81c5743045f3f4963d6f3cf2adf38685bba82c8c67"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fc82fc12235919d0057debb4376ad1102a9f914f8e0da4bb473c74506fa020e"
    sha256 cellar: :any_skip_relocation, ventura:        "1942c75b041b2ffd5b15664549297c06a558564f487f49b16bad3abb329c5fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "692aad4f078bddacb438898e625887ae1278fc07de6a1c9ce37ee9683cc5f7fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e08e8ced4f5394ad3f4990a092fa61a547cce4264127350f97912c50dda5f3"
    sha256 cellar: :any_skip_relocation, catalina:       "b2d84470b90f037632206b6318f87bf1024e0d0ed83fb8344e44642dc8751187"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2cc5adea6dcc3ef017b112ef05708e0fef1ee7a8205bc26542ee9ba023bc8732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e392648b006b21de93a33d1fbb1b5505c1de5353d0168368a71f15efd9a39df6"
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "src/perl/ps2eps"
    (bin/"ps2eps").write <<~EOS
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps "$@"
    EOS
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*.pdf", "doc/*.html"]
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_path_exists testpath/"test.eps"
  end
end
