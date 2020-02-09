class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.2.tar.gz"
  sha256 "4258d6a86d48d18da89ac9f307e8b6c6c93d5de59403dfc563db256317a7f576"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8e8371a6e3e7d8ae9df59818be1ecca6ca1e5cce80ac695759f13b734b9b887" => :catalina
    sha256 "e8e8371a6e3e7d8ae9df59818be1ecca6ca1e5cce80ac695759f13b734b9b887" => :mojave
    sha256 "e8e8371a6e3e7d8ae9df59818be1ecca6ca1e5cce80ac695759f13b734b9b887" => :high_sierra
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
