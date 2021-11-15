class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.94.tar.gz"
  sha256 "be616aed9babf4c99f7d95307e3c5ae449b253626d00f2928a679dfb263a6405"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "201e7cbcb0681e02eb6165f14182a45426a61ed52d3797432aaff0d01e42560b"
    sha256 cellar: :any,                 arm64_big_sur:  "a5f09dc1b4fbab274212e09dbcf37eb86ad96353f1451da8cd6d0cee13c24ea8"
    sha256 cellar: :any,                 monterey:       "e658f17a6feaf0076623197a0f3cc3cdd0cc6a2a9cd40fd5d0a082fa544d1275"
    sha256 cellar: :any,                 big_sur:        "63c494be4d54b01b8fdbbae8d1c9a3479cc00a47d082bf8c43a721d86fda48ff"
    sha256 cellar: :any,                 catalina:       "34ac2edaa8cd697f60e9858d483f2cd0dca2d17bfe2ecd986d8391b50a161348"
    sha256 cellar: :any,                 mojave:         "3548c29585c5b320bc7855f3a33c49639e8035d5fad9757fb24784c46aa17486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8caeefe2ac57585f7cda44463836caeab85f3f92f066e755d74234116b6a37"
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
