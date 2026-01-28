class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.64.tar.gz"
  sha256 "b8c11c323991dffa64de39dff32be24157b984bf34fb1d0d192f2537ec3f3568"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56072010b9ee8812f7d1a809ef5b70182c55f8340579dda9c948a3226f8ee6a4"
    sha256 cellar: :any,                 arm64_sequoia: "e4712f5e48c7eefa4717741fa78a477fda2db164a0cc0132a225808cfa569046"
    sha256 cellar: :any,                 arm64_sonoma:  "21c337a25702d4bb7b213d8b4af746f689b68d289c4dbfef602ddff1c63948db"
    sha256 cellar: :any,                 sonoma:        "6e6f3ad25441b5ab48e411d95ee0938d2f4df4d23ee6655cac4fb0f8364642a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8c47d28220098be00443ee7a2ad44c6264a634773cfa199b7f8ab32221dba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e10d24a22298d7e9ca4764dcb911b96a6ad8a5a3341442fe5f1aae86ffb100"
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
