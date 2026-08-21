class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.02.tar.gz"
  sha256 "d5d571f22ccfb6e9892b58a8af3dc5eb1c804a5e67732f863e2fba6d50a5369d"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d33ab0f40a30cdf42482c1a70f3e74ec8496ac14e87dfbe645be662b29ffac17"
    sha256 cellar: :any, arm64_sequoia: "3961da747a7e121e9d60745e7391f59de1d66f1bce9b7d11df7987f41ecd19b6"
    sha256 cellar: :any, arm64_sonoma:  "8691aedcecb2a50ac49525ca827b3485b3bfb2e96b25451660392249ad12443a"
    sha256 cellar: :any, sonoma:        "3647b7b6e4bfd82c075a0c9f76ef4426a6721444fe78b3da47811dda4e6c8923"
    sha256 cellar: :any, arm64_linux:   "87de7f222e01bf944135d9d0109a4f7a2677981e66b88a67833fb6c36ec53236"
    sha256 cellar: :any, x86_64_linux:  "9cb38605d07538c6424e1ae8dbb45294451333ab3a7e1073f98338cbc8890e3b"
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
