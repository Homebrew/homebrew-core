class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.25.tar.gz"
  sha256 "3d4b78435a8838eea8d5765622f2d251a81183ca5d0113a980d31ebf30a8f082"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e77dab213a6fbcfddd387d2550c7a2e4de9e155d2866e4c7669a8bd1686a790"
    sha256 cellar: :any,                 arm64_sonoma:  "baecc8010ec5c53717a4810aef1e2bf0009afaee999c60a5c5f856bb5a37ed45"
    sha256 cellar: :any,                 arm64_ventura: "1565c2f42e4d2995b1b8c4e29831b9e695d3df55bb394bfb35ecd47f28a87f1c"
    sha256 cellar: :any,                 sonoma:        "3ded91807fd14676cb990fa519f81c23bf6ba2d4755680cecca233c924159e6e"
    sha256 cellar: :any,                 ventura:       "4a849562d71ffd59ac664ff5a59e517a893a1af23537d9e78760d4565ff349fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976bcab19197bc8eb750d12c8dee131ce385179803579ba6e8e4c7474ad44f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794c49de78ad5448dbcac779065d7f6cf96d27dc07dadee259cc11bcc05ea7e0"
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
