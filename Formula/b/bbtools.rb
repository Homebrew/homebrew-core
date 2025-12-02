class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.54.tar.gz"
  sha256 "b869b7994a857d88bc28a588a5be5bb83945be85bc8b5ce14c72a9213b360ee0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be96e3e2491a3406760c0d8285c8550dfcc6ba06823f5f00c6d378c9b1c97e16"
    sha256 cellar: :any,                 arm64_sequoia: "a730908ef60611d72c4eb6fd34deb730ebbbc9aed6d3ec0089aacabfaab2a35d"
    sha256 cellar: :any,                 arm64_sonoma:  "a627b63812af043cf9ba15cad1b3f6cd9078f028ee971efe82fa4ec2804f9e0a"
    sha256 cellar: :any,                 sonoma:        "176c1345b67bb4e92b938551cecf568dd6edb58412bfec39701152a7f0dc6112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d193f7a2c9d7668306a2ee6d907f5b8906fb437a0d0cdae2ffd9e28cd2559a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14de597a59a71a2ff7ffd4c6941fd7f1f0d44d8f6833a30d35bf8c0838804c0"
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
