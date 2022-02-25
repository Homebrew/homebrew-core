class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.96.tar.gz"
  sha256 "18d9c89b02c0ab044b2795a65f6236b2262a494ed83d27e31750437b350ef080"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "683e587bedffcbcdd78977b635fd00fda5d9596c35cdbf3d54a4ded2985356f9"
    sha256 cellar: :any,                 arm64_big_sur:  "8b78c6aea85776310295d31001a4281ecaca975a6c04aaab8494880a4e4b496f"
    sha256 cellar: :any,                 monterey:       "7fd3f58fff2a6234a6e6d1c8ced09b062879a83551b377f5202c82b662e4c28d"
    sha256 cellar: :any,                 big_sur:        "0bb75cdc4bc43683311c717bfc7ab03caaaed45575fe1321df383ef7fbd582cb"
    sha256 cellar: :any,                 catalina:       "e4aba87066fc72a1a091cb64c004f672f4ef552e8c2670457403f758f049b8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239f57b37ec781b1a246aafd47ed4ca170d210b26d673643b906b200bd1105ce"
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
