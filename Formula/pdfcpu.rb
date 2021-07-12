class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.12.tar.gz"
  sha256 "e9f6d82460a3516691a7444d26ed339ffbe3d6307004e5340372c7ae09556065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "624219b4260f843a569e0118a960265074b37d37dd2ea540634d0dc95c79df69"
    sha256 cellar: :any_skip_relocation, big_sur:       "929a1b6879bf834d195e9811940469fdf5d6b26a0260e41b8821f0d3ca8a0fd2"
    sha256 cellar: :any_skip_relocation, catalina:      "cff4d99d6c310dc77d4c760b52e1c4b345b18682742f5b4bc575b4e4310a3275"
    sha256 cellar: :any_skip_relocation, mojave:        "cbade3938d02906c5689f3f16aeccddede49fb054264cb18a89972fc6398cf6e"
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
