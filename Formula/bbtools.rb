class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.00.tar.gz"
  sha256 "fa5be8f54a5f4c6b7031847538701479426bdbffc86b7ed7f419308a0d21a28f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecfe1eb5f582a17a456113bd53c5e108010dfe9947c21f1605bf2fd79ded4773"
    sha256 cellar: :any,                 arm64_big_sur:  "1fdb10930a4c94435dc59462da5fab40d0779c3abd85cfea1062607bd7666884"
    sha256 cellar: :any,                 monterey:       "3f06aef40eb9cbc16b7926ff2ce990dbe9812bb54ffaccbb9b5ec1e75daea328"
    sha256 cellar: :any,                 big_sur:        "5fa81f12dc0a25916691be24e003d976ffec1932d09e66e1216ccec0a2f31c51"
    sha256 cellar: :any,                 catalina:       "10b49c531cdcb3677c03c0531720703ac8c33df18bde071136134311c4ac77ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b59a699fd6b491382ec2b7afbc78c761180a423e14e9ac9be5217b58250a636"
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
