class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.88.tar.gz"
  sha256 "72b62d91b9b6e0aa157a26177c70690272f85b61e911c7c1f73e26c453c592f8"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42fb389488163cb64bb46bf4a506efb158541dc73cf493225675a8808130e759"
    sha256 cellar: :any,                 arm64_sequoia: "2c11749ed1ee53d3fa7dac13aba842c5bd357626020f25411fd4b84ac6a27443"
    sha256 cellar: :any,                 arm64_sonoma:  "bbd4c5a579728e6dc52e090ecfadffb8962f040fdff4bb6b25bbe41ed5edbb2e"
    sha256 cellar: :any,                 sonoma:        "883d07495c0aa8aa833a48861e1b57a16f6ba82f6872a13f3db1b688b527750c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b098f7e83fb334236b6d39dd846d2846b4fc713ad17d86aa7671e3e0f39935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ad0de88f1f546e8e85636d131bff71344d4bcc489eb0ca63b88e780ba3e909"
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
