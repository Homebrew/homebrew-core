class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.95.tar.gz"
  sha256 "744013cb24cc028af22957ae38796c7ff230b1dc9d0fbc874441bf9cf9b57556"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a6919fa3aa53172d0467a8c1dcab6b245d411302bbbf9ec8dd353344b3a8c857"
    sha256 cellar: :any, arm64_sequoia: "de2061c5ed0da079b55ddcd19a9d07f6da24140ce62b448e17161aa9ef756924"
    sha256 cellar: :any, arm64_sonoma:  "5a5d017ad5693f52e06689654610229fbcd569ebaf585bb2383d6fc2917d9855"
    sha256 cellar: :any, sonoma:        "6b163aeef5ff7695eebb6372a548a8f73b06a4f8d926ba230ff91eec4520af76"
    sha256 cellar: :any, arm64_linux:   "aa5889c3aa7d701a82b65fad650aa3f94f97b665da4e56f490f278b182c6041c"
    sha256 cellar: :any, x86_64_linux:  "fea39288c7fbe03cbc367e88d71558f43ec1170c046f6949691d60c03ad85a1b"
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
