class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.23.tar.gz"
  sha256 "1a6ec22bc8269b701b73617bcd1d67cc9f98d8539b70f253605ae9888538f3d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c12f877d4f552aa3aff9cfac1c19abf475ba23df2cc36b3e3191d054961ff2fe"
    sha256 cellar: :any,                 arm64_sonoma:  "4c152de969e4b90b2d128544da69eafca6f4f3d0c9625e93f7d6433a810f1136"
    sha256 cellar: :any,                 arm64_ventura: "d5f45cc3b431a645f50fd8876aa551d997a20911ef30b9603319b8c091af8224"
    sha256 cellar: :any,                 sonoma:        "856f637d0437a303d6957b870706a96baec691382a77d27d82528dda0146e7fa"
    sha256 cellar: :any,                 ventura:       "0176d48e2281b80d231255b8721b88f5d52e5b0d271adfae9810dfbc36692bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6b5f08d315858cc54b7fc881d9b255a9ba0995e7177dc4e198aa34165c0358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1d45e00daa612d2e4c1e5fa04ae5b98bf8a0722bf5b1a604333b7daf1903b2"
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
