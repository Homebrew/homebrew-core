class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.15.tar.gz"
  sha256 "b6698469a2a90f4930537c575ff1f70332f88a933dd5e286c83ea0ff30802344"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e2e6c9eb71acb93e422d74890feb41685a82583fa2818e5a9ea14115dfb0449"
    sha256 cellar: :any,                 arm64_sonoma:  "83f8ae6c0ec72386ed6e7eb4ea40b50aa0ac51b580ec16c3d0b720ab8d80083b"
    sha256 cellar: :any,                 arm64_ventura: "0f601648af71fcfd0a1c0b4a0b044eb581a0c90d7d92532e402e5ce8b39187a1"
    sha256 cellar: :any,                 sonoma:        "3d6795a1b502dbabcc421e6fd4e412edb5e1277c7ab88fd6fc75b45b12e9a703"
    sha256 cellar: :any,                 ventura:       "620f945600f738511aa7748dfd0a56b885d6667f160002445da05ff8348b7e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be664a227d87e399d4b64b65bf39abec66d1181524f37dbdc940452f93ebe96f"
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
