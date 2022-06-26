class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.96.tar.gz"
  sha256 "18d9c89b02c0ab044b2795a65f6236b2262a494ed83d27e31750437b350ef080"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5a3978e72e21c64260be9abc1e774fe7483068f20f535cbe69e8d0fdf74bbf4"
    sha256 cellar: :any,                 arm64_big_sur:  "80d0cf1cabeb3e5b7444cc502f648f7f8bb3ba6b76eadc81285cce1c5ba72ee5"
    sha256 cellar: :any,                 monterey:       "91b55caad3e49851078265f659be617177392ef7077a525cae1e4643a9db7049"
    sha256 cellar: :any,                 big_sur:        "44e8a7318c8d619ff0a7cd2295869f158761d28ca197bdb2a6accf5a0937821c"
    sha256 cellar: :any,                 catalina:       "3e306d31f8562469dbdb987ee78fbd1de6394fddfa17ded572dab05672cccdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02ef815958ec2fc729be2da6b814df18138de9a19b2ab237cf415bdad2de98a"
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
