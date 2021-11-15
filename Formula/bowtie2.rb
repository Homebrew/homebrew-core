class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.4.tar.gz"
  sha256 "ef8272fc1b3e18a30f16cb4b6a4344bf50e1f82fbd3af93dc8194b58e5856f64"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b4d29a024abe09a89e4e3c464636eb37e1d020ad167573bc717bc1d2218b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a32813ba9105f8e70c93ea9b66b290da4107a91fa09e7a0e8ceb9d1413050eab"
    sha256 cellar: :any_skip_relocation, monterey:       "04a436515c958e2d273ce074f1d03c740ab8b07d3207813cf400f03cc1dee23c"
    sha256 cellar: :any_skip_relocation, big_sur:        "96c8bdffc7e247135089bf5ebc6eb6b4ee1d7bdb82d25a56be5c55680c0a50e9"
    sha256 cellar: :any_skip_relocation, catalina:       "39a5b463bedd3beeb0f17e95da9a485bc0c95187663e284ca0b45b1a0e09b846"
    sha256 cellar: :any_skip_relocation, mojave:         "0b36d2735b4eff060d2ecf3d4a2c3fe71a88cedec08514a4bf6ec23210faf696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d14a1287dad374d8dfe98889d68a7f87aa6d2045dd0fd53fe7979b5c64f7b2"
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
