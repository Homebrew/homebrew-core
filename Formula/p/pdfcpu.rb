class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "79572e599deddfaa72109f3e029b74b8cd6070657355e8cc9d8c7fb91da73c71"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b00881dea2ce25ee9915ca16b8ffd072b62d6a0024e303f25af6ee9359737f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b00881dea2ce25ee9915ca16b8ffd072b62d6a0024e303f25af6ee9359737f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8b00881dea2ce25ee9915ca16b8ffd072b62d6a0024e303f25af6ee9359737f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b5b636b90de6b2bb44cc88cc6af4b4dadffdacdac95a0ce73ac091bbc48df0"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b5b636b90de6b2bb44cc88cc6af4b4dadffdacdac95a0ce73ac091bbc48df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea91e61252e6c55260c9e40ba9fde54ee4197ff73caeb153af952e6ec7b3c255"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      installing user font:
      Roboto-Regular
      validating URIs..

      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
