class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.4.1.tar.gz"
  sha256 "597421ef2df28a7d85ff1d1d04a9be3c3128d53e08ecc675461809d0a3dc9ef8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf624a797addb6674efd6511a076dd835b531e9ce399af883fd7aaf27aa99a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abf624a797addb6674efd6511a076dd835b531e9ce399af883fd7aaf27aa99a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abf624a797addb6674efd6511a076dd835b531e9ce399af883fd7aaf27aa99a1"
    sha256 cellar: :any_skip_relocation, ventura:        "1630b4db4f71f5f19581a0d82178c5257f45da5299b04276675b517a9457dd8d"
    sha256 cellar: :any_skip_relocation, monterey:       "1630b4db4f71f5f19581a0d82178c5257f45da5299b04276675b517a9457dd8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1630b4db4f71f5f19581a0d82178c5257f45da5299b04276675b517a9457dd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ea12a4c470d071a30297b8641d8749f8583664e0e71e01bcc89e9990990de7"
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
