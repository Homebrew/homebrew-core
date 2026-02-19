class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.75.tar.gz"
  sha256 "a5bf0c4d63b8effa02c9f6cd88309cb3c402dcfde129c57506efecec7fc5bbae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71be15b758fd99b04d6b6ba403129d6c2dfca5e390b6b98bf169c0a2255a3aaf"
    sha256 cellar: :any,                 arm64_sequoia: "92ffa32edd58dc63e3c7042d75a8e49d4f621faf882cb58dbcbe4f60da742a35"
    sha256 cellar: :any,                 arm64_sonoma:  "4c5bd8233714586c6240217cd5f05fa0ce751c57b8ca0e58a64460518f1aeba7"
    sha256 cellar: :any,                 sonoma:        "7dde401858bda5fe283c0dfb66e1356ebc52b64fc08d7885ca8b0fe932398789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8973803637fe7c8abea1405afcc2294144d0cc9efac0fda1062251efe30e95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ea9a0f5722a041477ee66e9d170e4d52fbe21c2f48e55400f95e26857aa807"
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
