class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.32.tar.gz"
  sha256 "713c457f938bce26b5a6425b2e2e69d6ea8c4bda5996d0df20400a3bf88c19d6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d77b5656479b50534e43beef33cf766db352d24dc67fa02ff64ebffd3f4dc0fa"
    sha256 cellar: :any,                 arm64_sonoma:  "e687ffcd882923c49cd2b69ded983caa41cbeb13bd810fd5a3e7780e8d3b918a"
    sha256 cellar: :any,                 arm64_ventura: "53f5628eada45a0193e7b1b83fa2b53e3a31626b8457b5953c8d423b4ce97e86"
    sha256 cellar: :any,                 sonoma:        "0df999f0250eff553b9155702b2bd14c7140ce523d9df8512cc9aaa0bb907204"
    sha256 cellar: :any,                 ventura:       "81aa585383ca28606b80a67a055ac41ce43832fdc9b01771fda7a5942a2bf55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439066ff391e9d68c9b85a518170588cc87bc36d03c99b1ee02340243665be3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f62d162928c644f88ef6622e401b149616cda1e35d86689766d4cbc4a514952"
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
