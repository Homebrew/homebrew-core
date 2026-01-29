class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.65.tar.gz"
  sha256 "556421ad9aeb1f079d0b2f791d7db9f1ba98079bebf00ab635f3cc23ede1ac51"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d36e801724d42cb24426fe25fe8b9502b106daba00accb45e94d7c58cc19e893"
    sha256 cellar: :any,                 arm64_sequoia: "6798816ccd042d782ece3c2ea0e8cb9e04b10a4513ae4b24fdd37ff0a1342c55"
    sha256 cellar: :any,                 arm64_sonoma:  "fa100c537a96fa910df4a11e21ed0d38d20801a4d5ff87502025b6ba97acfc2f"
    sha256 cellar: :any,                 sonoma:        "72832d445743ee160846bf960fd6339df1d4808c5a66ce45aa5916e512dd9465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f53ad093321f40564c3c3806990e4784b3a503a9c73c9cf91cadc2b7c972e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e004be65cc1988304bda1a80e8914cc8c12cf8b369755d31dc8ab419d3807374"
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
