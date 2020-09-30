class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.6.tar.gz"
  sha256 "59a9b1edf939b3b89b1a5e28cd54e7b0a5c9ce5fcc03db9eb43b1c28d7476033"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26a5fecaecfae13b08abdee8d1e1efcb5f02300c12925cc5da975cbb60ca366" => :catalina
    sha256 "b629627d5cbae53ed4eb68cbce63f482ca29967babfca0ab64dd93b42ced10e2" => :mojave
    sha256 "08e4a3f5c7123ac0caadb235cd2d303a91b04d4942e642a81cd011e710c4f1c4" => :high_sierra
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
