class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.08.tar.gz"
  sha256 "296f092ac5008575c656fba9c821e309d53eaac6c9f9ed17504765d592b244a6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d07b7e1a1885a7d0805644ebfd6c9e6cf0754e4a79932a5eb4c2af370c8a6c7"
    sha256 cellar: :any,                 arm64_ventura:  "b3a9e7b26e4383539052b5f5528bcab52fce890bba52b0533c96eaa3be484d06"
    sha256 cellar: :any,                 arm64_monterey: "fa7711333a2a61aa3f61c173a9be1c327eb6cd7282686ed8da32a5f83426c1f2"
    sha256 cellar: :any,                 sonoma:         "43e8e713b12cd81ea160b0540c83f97a77f5d2f157ae05ee2dbf24bfcb74ccfb"
    sha256 cellar: :any,                 ventura:        "bbef67beb5786796b5d1ebad42ba7649dfa0a781cf59f1990e491aafae7f0926"
    sha256 cellar: :any,                 monterey:       "7a6e1a6d4ceee293aa4a62b24832494ec0f010324210a7e8d2748299c256430d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea74f6be709f395cdecbde432729410bb747c8bb4da219a5e0601b83a3f4338"
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

    system bin/"uk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
