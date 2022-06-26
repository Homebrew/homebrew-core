class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.5.tar.gz"
  sha256 "db101391b54a5e0eeed7469b05aee55ee6299558b38607f592f6b35a7d41dcb6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb6c153e12bef52b933b8ec71b4d13b668575e48804687595435e216e7465d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0e1c79103307e874265d07ed9f2f611051fe7a3443bd860b4fcbb829b37601"
    sha256 cellar: :any_skip_relocation, monterey:       "1890493587a07ca8d73b6b414b63123516a3f0b5ec8b68aa81c87e8da252c0ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "103712ff11b6bdb397b50ba5e2507d4ad1a7f37befc964003e4eaf1951ec914e"
    sha256 cellar: :any_skip_relocation, catalina:       "56a9f6b9e3068dad1b51d47f33c116aae35c004e66813c004320c2657226412a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c64a45510404e8c5d9253cda6da9fd3f36902c6706b2f521b7d2c4a4d7ed201"
  end

  depends_on "simde"
  depends_on "tbb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
