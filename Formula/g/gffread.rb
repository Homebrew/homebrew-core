class Gffread < Formula
  desc "GFF/GTF format conversions, region filtering, FASTA sequence extraction"
  homepage "https://github.com/gpertea/gffread"
  url "https://github.com/gpertea/gffread/releases/download/v0.12.9/gffread-0.12.9.tar.gz"
  sha256 "3ee1a3a2db938569bcccb1e8d908503392ebf0a3f203ddaff1b967b8ade614d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc146d732fa9d7ff8575941815ef0d06f3a57330da3a7ec9f18daa3c92f56e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa002f0123c04ce5f9e4b24589d6487bad99a2381b739f01edee872c4e58a2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387db5e149ae11a55955833a00abd3d7b9310633a3887c94ca4ca073cd92cc7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a34d37615094a8ce4869a376bc42c594824b73e32f0dc37e7fa21eaaf8b5bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c6ff37eef9a58c0d9998112c59c8d0b9df539e1d8a6e054c195cae4db0bb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e89307727dd3730db1edd52ac69069225ebeb70b0cfbb4b0e117cbb67e40ab99"
  end

  def install
    system "make", "release"
    bin.install "gffread"
  end

  test do
    resource "test_gtf" do
      url "https://raw.githubusercontent.com/gpertea/gffread/4959f6b/examples/output/annotation.gtf"
      sha256 "f8dcf147dd451e994cebfe054e120ecbf19fd40f99ae9e9865a312097c228741"
    end
    testpath.install resource("test_gtf")
    system bin/"gffread", "-E", testpath/"annotation.gtf", "-o", "ann_simple.gff"
    assert_match "##gff-version 3", (testpath/"ann_simple.gff").read

    assert_match version.to_s, shell_output("#{bin}/gffread --version")
  end
end
