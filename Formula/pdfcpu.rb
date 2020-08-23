class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.4.tar.gz"
  sha256 "e4a088b008e29ef037665811abc027266fca1f5c5866d96d67c69de59ba87b15"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6678b5940ae2cc31abc7d551390d8b3d36b40990ec66dfea9ddf4f495eb3af6b" => :catalina
    sha256 "6678b5940ae2cc31abc7d551390d8b3d36b40990ec66dfea9ddf4f495eb3af6b" => :mojave
    sha256 "6678b5940ae2cc31abc7d551390d8b3d36b40990ec66dfea9ddf4f495eb3af6b" => :high_sierra
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
