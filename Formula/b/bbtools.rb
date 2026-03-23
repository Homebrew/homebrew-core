class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.80.tar.gz"
  sha256 "55883dda98f8402b1c20ea3aa1021515ff898c9540234c6a5a8214a76a5beec4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9120e190c6dce139cf117621e917cedbc5b5c6cd325cf88020469cf905ec671f"
    sha256 cellar: :any,                 arm64_sequoia: "68275593940352f7a7419a37c04986a3c26199e4b655ca6168010d2a84ee5645"
    sha256 cellar: :any,                 arm64_sonoma:  "426d79cb8873615386420855b791644e55534fa26973e6ddd10962116524df1d"
    sha256 cellar: :any,                 sonoma:        "0287b95923d8c9152abfd2460c75eecbad67fa34e26344889ec3343b1179de0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6436866725d517fcffe139231c255c51324a1d4e5fbac8db3d6ef3dab94ac2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a4f8431ae74dc6afacad0ad0d7e3f27fcf622061d72d675c817756769cb6fe"
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
