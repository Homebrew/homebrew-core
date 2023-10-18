class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.03.tar.gz"
  sha256 "876263510e60207612b00e1a5d45e6b3f9085d60cc82e952873dd97cf25333e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3376423f9dfeb9437c01b940c59262813e3423e31b46265cf095d848f85bde17"
    sha256 cellar: :any,                 arm64_ventura:  "405f5fc94e9f30bd2a6358c106590b2d0e92e5de71f0ba2c1ec17801f61a3b2c"
    sha256 cellar: :any,                 arm64_monterey: "e3fa3b725fa056de79342fd9a4e9f3bc81e734741e9de452016835ddbc51859b"
    sha256 cellar: :any,                 sonoma:         "f6449ac54fb8d47c2ccf1cccd1090d0796d1194cf1c9fcabf3139008dba5b165"
    sha256 cellar: :any,                 ventura:        "55e6eccfb10b7fd8858ccfd56c6ab95a3f4d2affefdc6921e070ff1ce2b029c0"
    sha256 cellar: :any,                 monterey:       "db4440df951700aa1bd123049d47bb5486add8844a1ab712fe9178f96b392874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109c1931576fb61afbc6e5e40b52bc70bfd8a4814db4f69941558579f3307f3b"
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
