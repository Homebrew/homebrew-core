class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.8.tar.gz"
  sha256 "7453c666570e8b93d9b71491f9b36192f80aafb43081ca9643cfed401341f465"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b4663e900c5f692f973cd821fffd7eb6568300706710f6ef4054fcc4dc33135" => :big_sur
    sha256 "ac34d106830f0151a271addd85bb96c74826a8a48b8a2c7a1f5518df6db628d5" => :catalina
    sha256 "293b075f32a26c3b835b9a45f125c61cc87273bea16449b4785d791501dc8170" => :mojave
    sha256 "d3485d7bd4d37008a2e4d38b7f8cb772eb9b76827dd198056ef3895296611842" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"pdfcpu", "-ldflags",
           "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}", "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match "PDF version: 1.6", info_output
    assert_match "Page count: 1", info_output
    assert_match "Page size: 500.00 x 800.00 points", info_output
    assert_match "Encrypted: No", info_output
    assert_match "Permissions: Full access", info_output
    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
