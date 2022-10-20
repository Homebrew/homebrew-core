class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://www.tm.uka.de/~bless/ps2eps"
  url "https://www.tm.uka.de/~bless/ps2eps-1.70.tar.gz"
  sha256 "3a6681c3177af9ae326459c57e84fe90829d529d247fc32ae7f66e8839e81b11"

  livecheck do
    url :homepage
    regex(/href=.*?ps2eps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdadaaab653031dd42695d12d97e7b831e15d6e823f00abc74a5a2f89a7e4954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb048bafbe5b44a17151bc81c5743045f3f4963d6f3cf2adf38685bba82c8c67"
    sha256 cellar: :any_skip_relocation, monterey:       "692aad4f078bddacb438898e625887ae1278fc07de6a1c9ce37ee9683cc5f7fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e08e8ced4f5394ad3f4990a092fa61a547cce4264127350f97912c50dda5f3"
    sha256 cellar: :any_skip_relocation, catalina:       "b2d84470b90f037632206b6318f87bf1024e0d0ed83fb8344e44642dc8751187"
    sha256 cellar: :any_skip_relocation, mojave:         "170231b1c48914442e5c4eac304652b1aab7603c46d407f26b1383b932e3c2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e392648b006b21de93a33d1fbb1b5505c1de5353d0168368a71f15efd9a39df6"
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "bin/ps2eps"
    (bin/"ps2eps").write <<~EOS
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps \"$@\"
    EOS
    share.install "doc/man"
    doc.install "doc/pdf", "doc/html"
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_predicate testpath/"test.eps", :exist?
  end
end
