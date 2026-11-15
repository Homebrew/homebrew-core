class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.05.tar.gz"
  sha256 "5053f2375b48ff1a74f9f47d5e7c3698e8aa68f9474eda067f3ed792fe285495"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "744cfb55ce43f68d8080bd1093f1817ec3b64850217079b97dd68d0a578e799c"
    sha256 cellar: :any, arm64_tahoe:       "995a29d0b6a92ead4b79cbc1e40e895da843746f8d84b8b67a9d504285788f1c"
    sha256 cellar: :any, arm64_sequoia:     "4fde60858de437b942ce4fa25be6d1a89d36e6eaa92e77b36172ec4fe74166c5"
    sha256 cellar: :any, arm64_linux:       "2da85f6017887e3ff65bbd3fd3ca2464f719d1ff68708250959361988c30458f"
    sha256 cellar: :any, x86_64_linux:      "1cfd0c82236baefa336162c8e80c5271c7b9923465873f76525919917fceb0ae"
  end

  depends_on "openjdk"

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
