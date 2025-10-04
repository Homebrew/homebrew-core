class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.36.tar.gz"
  sha256 "f5e87b409fa58fea352343177d208c0c03536cf9569cb802a7006db754a6f99b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fab8a8a3845b704e33e50173561d782a21a59b9c494a94215fab94522a98041"
    sha256 cellar: :any,                 arm64_sequoia: "e635edc1c5eee8686f521f978f98b2060a5f32f211be6b95f4242ce32484dd02"
    sha256 cellar: :any,                 arm64_sonoma:  "35481f719dcd0093505e077bfa9e8c9404978f7ff07c869d79e092c1480829fc"
    sha256 cellar: :any,                 sonoma:        "93423663909952484f65fbabd0e64e40be76a336ee55f5e6b9ba3414c607605a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a505790c35623de557564e891bcdfd6bb1fbaac148d06015177aaa2de3f97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd633e284f4d03bd7c5bf11151e60e57ac019cf9367c240ba3f2987924852eae"
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
