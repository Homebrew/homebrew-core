class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.4.tar.gz"
  sha256 "ef8272fc1b3e18a30f16cb4b6a4344bf50e1f82fbd3af93dc8194b58e5856f64"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "540b354db85c68e4be5276c7a68622b260cf53da5366c11337eeb8e690432b1f"
    sha256 cellar: :any_skip_relocation, catalina: "8f4ef8f1c8ed01f4fbd930e5ce6ed9363622d9511d33d7d899ec4d4ba194c27c"
    sha256 cellar: :any_skip_relocation, mojave:   "9341eaa91888215e685123847a3e87f91a2d140612dcb8d1a3850c01c335fc2d"
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
