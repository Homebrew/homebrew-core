class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.11.tar.gz"
  sha256 "d538acd82b7beaa7c1ad29f8bc2455b28975551904290f1093484f328c359cff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efd9484e1d092b0ece59f5eab702065a3e561548ccc2c7ea2784690df80ffdb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "51cd5f3eaa11f138ceea6908cbaa8589eaa242aaadd05b503963ada21fe1326c"
    sha256 cellar: :any_skip_relocation, catalina:      "03a91d21d7c2c45c039c59ce0d1dcd65c93e7a9b0086d66d0deb5eb16be7fc1f"
    sha256 cellar: :any_skip_relocation, mojave:        "530f7b93cb4eea8e7bfde44d8a5a1d7e24dcd2647ff71e41a9c5770e7e800726"
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
