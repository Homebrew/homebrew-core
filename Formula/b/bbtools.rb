class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.97.tar.gz"
  sha256 "ba710806addd1e8e4ccf2caf1f3f8d63a32f6730bd0eb91acf1bfe4f71e66447"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cea618c3255db1e6594da302f7a6a2b1f68084ce03603efe6917f1547ec8cf6c"
    sha256 cellar: :any, arm64_sequoia: "02819176d0b59228513b81f8522b816a2ffda98582bf63282d6723c89f98dedf"
    sha256 cellar: :any, arm64_sonoma:  "6ad2a86253d7b8796ff20eb4c765a437d94423b0a4f2e1c368bdaf9c940c1062"
    sha256 cellar: :any, sonoma:        "0b328781d40e104d72549c0caad86c2966ecc89c95aac505eba1703ce1ef8647"
    sha256 cellar: :any, arm64_linux:   "dcd8d1d2c669ac1b73b8b6ea481268f8e7021c17b538d2547cffb7c9b89c67b6"
    sha256 cellar: :any, x86_64_linux:  "f15f41bb6806743016e5a5274e2e6aca6e8c86b894342bf7461798b53113b149"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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
