class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.5.0.tar.gz"
  sha256 "55dedeba8bea240d3ce3f46211d6e14310035c1de5a3e9ac33f72f739165fea0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2105ca0b03e8362c3f700da25f436e7aaa3a296dc6f09a511e18bd004c0bef01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4682917b22c7bc0f3ce2ef3baad4f1d95c510cf5c7639177ee07612c5783e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91bce9d10f339a8c83595112691b2b6205fc6d4e61e63d46f2f8f7c32d8380a0"
    sha256 cellar: :any_skip_relocation, ventura:        "4558f49d23397aac8d27c0a2c14529b57af08f894e89474ff914dc067addb2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "a2067f6944a3e80808476582ba2dcd3da72d791bb8c9371d4c8dadf47749d34c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8086d31b98a4fee884fc459cb01f33c98e57fedbb9651273068e3709e54736b0"
    sha256 cellar: :any_skip_relocation, catalina:       "5bd8be0504e7806243d33210f54de2c791521af72aa35897b33e14ec1aa734b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83bdfb506a8e464f6adec0342f12a3da423a01942314a853e962230595610c7"
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
