class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.7.tar.gz"
  sha256 "9e473f3bdd564609dd85e26a09e3a970add5617f1a1b9d5d418c7a55e1755727"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "69c0ff70563f539aa68c221374fe8c145dfbb391b3848e35360371a62ab8f071" => :catalina
    sha256 "13d7bbca13901ae2aad57f99a2293136a1221996bbd1834c401d68cd78e3a391" => :mojave
    sha256 "3d4cf37450e27a34eb68f3321ff00f3a888cff219c29ee61b206d5ca42441f97" => :high_sierra
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
