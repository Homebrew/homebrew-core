class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.51.tar.gz"
  sha256 "2befe5be5cc8972e4d95e9b4b33c4bb1e00d734585201aeea85527a5acb5ca1a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca1fe1368c619d8f9185a6d2ae95f52b280ca701a4878013fa1a6bb04c928096"
    sha256 cellar: :any,                 arm64_sequoia: "1e577af7f4b83208d3fdda17d6787816cdb92bab7205d3f7f0cc80318039a4c1"
    sha256 cellar: :any,                 arm64_sonoma:  "623768a800fd9988fd966d16d9699785ac1c1cc80b68735ebde2fa0d1ee15d5e"
    sha256 cellar: :any,                 sonoma:        "633659737613a1e01ff7dbf4df37c96af0820f44db6ca4803aebc3de5f44c3fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c43354aad3193a70c5a7a61b41fc3d2457002ad6b760d50530407f4cd27b12cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ce413fe038ca11243ae90a00068fb5d32b4903fac00a4b5023cdd2e4e3cf99"
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
