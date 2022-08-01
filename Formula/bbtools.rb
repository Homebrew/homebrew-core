class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.97.tar.gz"
  sha256 "1bb0baf9e57e699982d7bd965942fe9f7462aba92e4fee3db19aeeb077a5aafe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b8cc8fff665314729772d1ea64c307b784b9c4603622494f53a2f57e060f190"
    sha256 cellar: :any,                 arm64_big_sur:  "ca46c105b647a8d7aae4c078584b98f8d1ea40a11699d7f7b7610fa360a5136f"
    sha256 cellar: :any,                 monterey:       "78471c7b433f8cacb232a44d9fb0d3b02b949a71b65a53809309cc7b2f435b32"
    sha256 cellar: :any,                 big_sur:        "f296c28ee9547aa584a89aeb870f84f31f343904800335501e7e343b17e10a07"
    sha256 cellar: :any,                 catalina:       "c4b077b247c047eeb75b0b1d69bfb97f00c5a78a1e036a68efacd01991db943a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f531f6bd46cccc7971d04b99dfe2368c0c06a335d1135a97f296abab0e42dfb"
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
