class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://github.com/s-andrews/FastQC/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "cad8bfd11ecf388204c28a62b162dda032aac8ecd08819c49b053aa66613e92b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.bioinformatics.babraham.ac.uk/projects/download.html"
    regex(/href=.*?fastqc[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98115fa6cc5acc2f8ac59e42843802c5e4d1484be2b030edbeafc32ccdac89f6"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  # https://github.com/s-andrews/FastQC/pull/109
  # Remove with next release
  patch do
    url "https://github.com/s-andrews/FastQC/commit/d4f2e91d67b765867b59cde3c6a9a6c7de34ae37.patch?full_index=1"
    sha256 "0ccf32805c574e72823d5a22a6d7cf99eeac74fc5779ff6ae695ce5d32b7094a"
  end

  def install
    system "ant"
    libexec.install Dir["bin/*"]
    chmod 0755, libexec/"fastqc"
    (bin/"fastqc").write_env_script libexec/"fastqc", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      @SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
      +SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    EOS
    assert_match "Analysis complete for test.fasta", shell_output("#{bin}/fastqc test.fasta")
  end
end
