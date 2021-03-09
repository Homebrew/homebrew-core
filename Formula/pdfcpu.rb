class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.9.tar.gz"
  sha256 "8391671f4135a90e0b25ac9b24c3fe0750caee15b0e5c9e5f1912855fdf313a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "122aecb2cd82e1f5af5b2523666c7301aed1d9856ea81cf7a5ea0c3290a1f927"
    sha256 cellar: :any_skip_relocation, big_sur:       "01b9b0b91d99d953e94087cfc2e8ed1e70c34c97d8ac0f3ab4fdc83b92e8be70"
    sha256 cellar: :any_skip_relocation, catalina:      "775aaef135989f53de0d8da36d13161ae62ddb981a3326a81f4050f5724b4ce3"
    sha256 cellar: :any_skip_relocation, mojave:        "6850b47349d59cb3be388dc728dc596fe5edcced697abc1bc2d6eae6ea8b6344"
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
