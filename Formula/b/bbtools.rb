class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.10.tar.gz"
  sha256 "996aff05765ba5e64547f8a34c56da396ce7b18db96ffe7f1076f2d2f49c6148"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c0fe9a575a8ad6331d5c8f9f2922fcdfc6c89d22a55a718b19efe79750134f8"
    sha256 cellar: :any,                 arm64_sonoma:  "d86f1268c6cfe4bb3e35227ca9b9aa9be4c40ce642b2ce0730f944f50d6657c3"
    sha256 cellar: :any,                 arm64_ventura: "017c4c6997e879a54634ecaf61de8c8627f95ceab57675caa52902fb6ed8fe70"
    sha256 cellar: :any,                 sonoma:        "6220e590f5476aafdee633c8d732e782222816624dc912ed3e2d63e2c6beef5e"
    sha256 cellar: :any,                 ventura:       "43f9e3fdb1d3af404891e7714c185da35ac0779d926aa17ae4d7819182eef5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76022af912cc8f03766580166e6af7a95ec90aa1d1375e8ccd579740b70b761c"
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
