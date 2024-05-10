class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.06.tar.gz"
  sha256 "61d45bd59a543b90a143c5c7dbfec0ff6163dce54194b8c4b648fb6aac67d42e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6edd68a10a22646149eb4173525c1dec3723893ee0b1a6185f220bd28815b104"
    sha256 cellar: :any,                 arm64_ventura:  "a40a22ea51d66ca87e1f755286a810fc585ff1129f85a6be2683230c5aec5510"
    sha256 cellar: :any,                 arm64_monterey: "1b22e312ecb9693af42a5ed847d934779c845f8d670dda57ed4e991b7170d5ff"
    sha256 cellar: :any,                 sonoma:         "ca5b6057b86a04cdd799e25ed5c08b1cf8f8297157b74c378e646553e1223aab"
    sha256 cellar: :any,                 ventura:        "12e5092d30fa2c7e01f7306373d11951e515a14756b6832d6df87dd7404032e6"
    sha256 cellar: :any,                 monterey:       "ee4179a9a2b10c145cd5a0fda1f5974b6df127b3367616a08cb7e8bd61ebcebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385b3d5ff34f9fe7b90cb15b3a5788878048873e70f0d9414ed9fc8de408d98f"
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
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
