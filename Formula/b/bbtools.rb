class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.43.tar.gz"
  sha256 "a45d292b2338299decfce9155edbae36b2c190570c5ab38b22a83051973e4deb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41ae01992e8f3273f0e2ccd9c50eb9bbf3226c90fd1d6a8a4b902794df194b2d"
    sha256 cellar: :any,                 arm64_sequoia: "2318111bffa7b165d4a57128fa46d4c62efb169cd0351572e3495c9e8f2bfd7f"
    sha256 cellar: :any,                 arm64_sonoma:  "387d9e87fe768a5cd562eadd52761b79649002fbea2c0891483a3a9241b82ba5"
    sha256 cellar: :any,                 sonoma:        "863cc9c3d519b13ab27e57f51fe181a46ee8f85eb53af2536f9a332af670b462"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73406a69da295325d1c0bf76ed4558a70934d7735f459331ea1c8e3d239bf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6c467e04e47c75f4dcbbece9d626f7c13597b8f830e276c27e4ce0588c56c7"
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
