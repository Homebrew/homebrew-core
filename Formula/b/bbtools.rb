class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.64.tar.gz"
  sha256 "b8c11c323991dffa64de39dff32be24157b984bf34fb1d0d192f2537ec3f3568"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40d2912ff3448e2dbf6eba10fd62a807c45a6bb29944adfd2b169cf931c70abf"
    sha256 cellar: :any,                 arm64_sequoia: "c32d47b5deda12ceb870ccc0447a86413a4b6e15067b4e5576c4929bdab5075e"
    sha256 cellar: :any,                 arm64_sonoma:  "083488fa2834eabcb989bf8a0be2725120b3f3244aac3c29d960512260b20f11"
    sha256 cellar: :any,                 sonoma:        "013076cd2496235caa365dda10fd9b32bc338d53184011cf9be32ff254fec519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a61f138f043f4462eade985f46357f101b34d71d76eadbc63320dd2707af96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee5b32e26dc9499ba8c7386e08cbc7457bb1e672277abd943626a2380dbf009"
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
