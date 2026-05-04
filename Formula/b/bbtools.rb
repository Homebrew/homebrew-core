class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.84.tar.gz"
  sha256 "34968a6b143afe8062704557a1c94f4c4d82c35c61f6fb21d69e5bf528fded4d"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d68067f8ce6dd863834281a8e4f0105e26913d74122e730950bb3840fb2a54a"
    sha256 cellar: :any,                 arm64_sequoia: "a5fc10a857fc8c2c33e781ac93e1320a49de427ed1bf80f2144051ce810b9295"
    sha256 cellar: :any,                 arm64_sonoma:  "aa4b7dd4e90d276b651f58a3816cee426a422d5f6f54d5ab6d7c04a5beeb6c70"
    sha256 cellar: :any,                 sonoma:        "103431269fe38d075567148c5625dd729ced9239fac4e92cc306187f47689128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f138333df5efd6e44473ed2ebbb82b66eb00bb5b2d1228a28bd089ca9b17cbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648ac1f3893e05afebdf72ebb5fa9c6f951bbe0a3b7f6ca7df654333eb08d2b1"
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
