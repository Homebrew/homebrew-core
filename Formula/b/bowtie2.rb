class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.5.1.tar.gz"
  sha256 "3fe00f4f89b5dd85fd9317e2168ec93f30dbb75d7950a08516c767d21eca7c27"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a5f45f3bf45cffefc8598581d5547169d8e07f6e3c1efd31898e36582eebff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d96c890b137f91f46544d867f98186d03592848e2e77939c8af952c5b39047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8421e1f412403865337c4a9af25a7144ee89d691367864ff91440d7faa73a420"
    sha256 cellar: :any_skip_relocation, ventura:        "594c8dcbfbb4acdc5628a75eca10e691dbf7fa52602a26295618d6291705c73d"
    sha256 cellar: :any_skip_relocation, monterey:       "e59ed1f423747d14edd5cc80c1f5985f622e00b17babfd7343e7e2fd1e730468"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e5eeb5344bc134741c981997984622105ee104e7bcdc301e86a289b98ba9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825b7afefdf1fe78b37362eda6e6706e3c850c955fdd01fba714232ff187051d"
  end

  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_arm do
    depends_on "simde" => :build
  end

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
