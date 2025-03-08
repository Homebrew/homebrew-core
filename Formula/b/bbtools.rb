class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.19.tar.gz"
  sha256 "9865aa6732f8f3bed071bdc7091165c02a864be6d39d49ef321bf0cfd13093b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c9049c807f191102c7bcacbda1e6a5e6de16d9d6e5334e61945f3ca78d989bd"
    sha256 cellar: :any,                 arm64_sonoma:  "198da729b7d0d07e26c4a0a991575172700ae4909420979a435efc03aa4435db"
    sha256 cellar: :any,                 arm64_ventura: "190ae4ebde171e48688af3b7966b7b98d6bbe58fc01816b7b806758ea8706519"
    sha256 cellar: :any,                 sonoma:        "97dc175a2b54950b0dc56df0e1b246035ace85e81f2eb336157b14ceea967ec0"
    sha256 cellar: :any,                 ventura:       "8f43186fdb48d084fe2a1204d2bf8c31ce6c4e9c7f812dac12f5365402f6572c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b331b8896e763936ab009a4c35afa93e78267feef98979628717c3dd0668bcba"
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
