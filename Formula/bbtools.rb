class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.92.tar.gz"
  sha256 "a5db3921684296dcbcabd0d36dc123597f587a6ac96855f4f901fee494718dc3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ac32addd7fdf61b7f0072980a55552fa61ef57c387c633dc7afb25bfeab7b6ff"
    sha256 cellar: :any,                 big_sur:       "86ad5237c649731c3d776feaa57dcc8a42de27ecbb6f118b88f30e7cfbdb1806"
    sha256 cellar: :any,                 catalina:      "ec7a14d60ace4d66412f4369e0e70bebf8c4cfe335573587ac5c2b3851b45ebc"
    sha256 cellar: :any,                 mojave:        "49c3ff880ccfa4eaa2acfaa5bdceef3091b7455f260562c9343406efa67a2e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a741261d9e9930f7c2eb24f7d748d9a711fd90d4115b904d5c7d22cdb7cf5ad"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[current jni resources]
    libexec.install Dir["*.sh"]
    bin.install Dir[libexec/"*.sh"]
    bin.env_script_all_files(libexec, Language::Java.overridable_java_home_env)
    doc.install Dir["docs/*"]
  end

  test do
    res = libexec/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
