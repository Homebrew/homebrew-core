class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.34.tar.gz"
  sha256 "c9c096c6ce3cc87da5607b731532bb9ac0aaebea2bd8fbf0a56e235968c4fbf4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19a90cfef884f44b2162969597d05d8682778116d97039951e5cf42a08b06b37"
    sha256 cellar: :any,                 arm64_sequoia: "ecd0941e245ccd7027836fa290b7d332bd9d539d1cacf00ddf7c19dad6a002f6"
    sha256 cellar: :any,                 arm64_sonoma:  "2b08517d085e97c72c3e5084a003123ced9dcdd18e8a63dcdc43a393fedd7c70"
    sha256 cellar: :any,                 arm64_ventura: "98086910e731884d8f80bf281e6c5ceca483dab710c87acf0c69e8e224e5374f"
    sha256 cellar: :any,                 sonoma:        "96e84c1592d94249d5daae0440d96ddbd91413a7db91520d1556c2a51e308046"
    sha256 cellar: :any,                 ventura:       "be5ca998ef6edbed27498a28b25f26bbba98dd1ee5b6c7829108b27119fc8d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035215335c219ad978aac442d4a02e791401c4f9ae8b603f5c6ee1943fe536ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de9d467a89aa34c74b62bfadd7585de16f3f5ef82d51459a4a0f1de90b45339"
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

    system bin/"bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
