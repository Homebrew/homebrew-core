class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.98.tar.gz"
  sha256 "cdc3b8e0530c4a83a728d28da31f0e7ead2bc233d4bf21cd1916572c9b2d0e0e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51541c4b8a3ac58e8c3d89544ac99c802bdf3a22d3b98920f70b8e7e43e3bf42"
    sha256 cellar: :any,                 arm64_big_sur:  "cd24a52f10ab3f630b93aadf4f058093ff03528b79f39a5c0ca08370b1fcc61e"
    sha256 cellar: :any,                 monterey:       "414f934c32f1de25719235562403fad0ca7f54f6801c1e62d3a7bc6d48a6391c"
    sha256 cellar: :any,                 big_sur:        "2193c8149f4e917e0fab546ec8ec618bcad884f43fa5b18439c245c44fe5c8c0"
    sha256 cellar: :any,                 catalina:       "178b274b20fa934e38e7c615233233062c569e4c1db309fce779d90637d8159e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6969dd969943e0d45dfbc7f80c139812b007266ae2cd5c7e0d59f1bdd717d3"
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
