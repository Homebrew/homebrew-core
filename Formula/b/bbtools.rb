class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.35.tar.gz"
  sha256 "0762b3e704c4119e9c2f4855ce0ef9813ae0fd69c997e1af135aa2d80bae7cfb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56559c3d2cafdbd2e65fce666fe02fb182539ccc62f6a8026fd728a7904834e5"
    sha256 cellar: :any,                 arm64_sequoia: "17a7b699655f916112d0865638bfca49f3e1e64f9bc1f6393e36d402232c2cbe"
    sha256 cellar: :any,                 arm64_sonoma:  "f1cd2894557009cdff7ddce552112c99ac3bb90c6e8ffde336e21b7b1b3cbc74"
    sha256 cellar: :any,                 sonoma:        "5122ac9bafc6517a80207d973b6af67e319240a47f8d4995a20d6234424ae789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c2a7e29ff09b2cca357f79a03bb7a763a3c95f8436795782ce07f4b985069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b85b2187fec247d1bfb2185817361b1b9f1201b0d911891f29ff5955d3f1907"
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
