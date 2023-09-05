class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.01.tar.gz"
  sha256 "98608da50130c47f3abd095b889cc87f60beeb8b96169b664bc9d849abe093e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee5b3030f1acfe5105146f15689f3593356eeb1fcd783304d82120a5799e53ca"
    sha256 cellar: :any,                 arm64_monterey: "4f724b3391445cb3801dd8add9f385111f5d0ce8df1fde3956b71c7778df1a31"
    sha256 cellar: :any,                 arm64_big_sur:  "8f5328602a99242b650931945bd1ad3b3fbd4da8c8ebb76a615148835fcbeb27"
    sha256 cellar: :any,                 ventura:        "1e020f4b8b859f2d173f42c86eb8d6f03c90f4b33c4881722d32f0375d7cb500"
    sha256 cellar: :any,                 monterey:       "fa2231392ff7a5cc23c618d3ede17dabf7c39fcab96af981f34a44d255d56986"
    sha256 cellar: :any,                 big_sur:        "91b2d7d2cda27ae13fd9aa955874f5a3be3af97b481ee5d23ac10e09c54da33f"
    sha256 cellar: :any,                 catalina:       "2edf1f85161f3a245b29fb55b117f074d04c0859cc1abbb9406ac98c038c7730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177acf4ad3c84029f0f067afc3c4838e8cc91ec4f693a02554eedcbd86a3f379"
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
