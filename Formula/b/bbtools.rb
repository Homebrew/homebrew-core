class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.26.tar.gz"
  sha256 "cbeaeb53b7d9051b16f5b15a1628012f053491da0c1684bc88ff9aec69b331c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb28c1f4ff3be3c7602cadf26545918f9de4109cd46589d25cdca6418ded0e87"
    sha256 cellar: :any,                 arm64_sonoma:  "29b4482d36bcba130bbdf7f1d53cda1ca62213fbcc8dcaab820839c2682f889d"
    sha256 cellar: :any,                 arm64_ventura: "fafe4b36afa6c86ae609a3ddddfe44018a0391a92a9b402e5318569e9a3a79bf"
    sha256 cellar: :any,                 sonoma:        "0b7ed3abed41c512005587820d92103dd73a0dba6e034a436c8f7454a39bd972"
    sha256 cellar: :any,                 ventura:       "55d25df7794df66887421f58f9fc7ddf13e09cbf3c2ed8698c7d02a687da056f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331c0d52304a402f5820d55321e2388824855d26826d71e20742a994ec79671f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f4ebc32fe181eadd79d64d2863450d5f29f5bce8ab3d17192f132c91a5e8d8"
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
