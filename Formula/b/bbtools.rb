class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.06.tar.gz"
  sha256 "672aa3409168bcd8877b781abb80d324bd05375cbea7f447d0b8759638699472"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    manifest_sha256 "1ecfb3fad13e8a98669ae1a9540eee7fec47bf4d43eafe607fa39e987a091dfc"
    sha256 cellar: :any, arm64_golden_gate: "7452fce62e08c0ef7a8dfa52ad9fba3c5a14c0cb25033b05e957911d9a76a763"
    sha256 cellar: :any, arm64_tahoe:       "688f314ea90cba27ac3f215ebaa18243e098c54491f1014702d79bcf477b379d"
    sha256 cellar: :any, arm64_sequoia:     "e1293ae2798c90a89d4f7aa3877ac2ec70d80898f73d730f3e5c1b878b485dab"
    sha256 cellar: :any, arm64_linux:       "fc597aecf31a097340a84e0f1ea990afb06a3ce5daf2ee4a985f22b6c2660fe8"
    sha256 cellar: :any, x86_64_linux:      "03c3e581b87baee5ecceffa2ec54bb84c1471591b78ee373de1a5b9b48e62520"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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
