class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.43.tar.gz"
  sha256 "a45d292b2338299decfce9155edbae36b2c190570c5ab38b22a83051973e4deb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc0bde90b3fc67f81876d88aca455bbe84eac0585d98fe7600e8200b75e8cf58"
    sha256 cellar: :any,                 arm64_sequoia: "e11286c615a278700091a0d6d67334b7becfeac4d7f95ec4a029f16761665177"
    sha256 cellar: :any,                 arm64_sonoma:  "b9c9675ac280ad4ca584b7d7dc2495e3c7d28667e27f04ce10368b0619b5f9a2"
    sha256 cellar: :any,                 sonoma:        "518fbc3e1a6118fe0a32da6b35e3d03712e188ca1ea1fb0abdeb8dbc35cffc89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0720baa67563aa2fbf9bbb4037d6c3f02e38af89bc03efc819c958fb78a9b1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1ab377a6119d3da0f693082ae648990cc6f3652363152b08a1de2c73639198"
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
