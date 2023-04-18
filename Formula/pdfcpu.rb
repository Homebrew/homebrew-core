class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.4.0.tar.gz"
  sha256 "c80cba8a110f49bf4c3e835043ed3b2494e3c61913c4eeacb5174f10fff3a8f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff348afe15ddef60bc72cc0ca564b7d637df64efa24a5084ed10aa7f18b30df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff348afe15ddef60bc72cc0ca564b7d637df64efa24a5084ed10aa7f18b30df5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff348afe15ddef60bc72cc0ca564b7d637df64efa24a5084ed10aa7f18b30df5"
    sha256 cellar: :any_skip_relocation, ventura:        "369aa07182083e08fd5fde8fb1c4ed10eaaaa689de27f0ad95d64ba2a99f5931"
    sha256 cellar: :any_skip_relocation, monterey:       "369aa07182083e08fd5fde8fb1c4ed10eaaaa689de27f0ad95d64ba2a99f5931"
    sha256 cellar: :any_skip_relocation, big_sur:        "369aa07182083e08fd5fde8fb1c4ed10eaaaa689de27f0ad95d64ba2a99f5931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ab4500ca0cf890695246d33886d1b24e5bdcb64b1bcf23278ce3c39e6cb24f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pdfcpu"
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
