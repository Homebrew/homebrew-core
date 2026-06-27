class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.93.tar.gz"
  sha256 "f78370a283c48ee517547d46f593183c6fff9bd03ca8b68b9955c35b734b5253"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6893dda04dc9f561288e5bcdd6163319ce8ade0ce9ac05fee884ec95a095e26"
    sha256 cellar: :any, arm64_sequoia: "8f9fa3998a43c747394c044394418274110cca7b4724c4136448346b2d69bb62"
    sha256 cellar: :any, arm64_sonoma:  "1bf707e2303d77eb7b531f6c58161b41de0843877d55b2fecbaad460c1620188"
    sha256 cellar: :any, sonoma:        "57de162dab65b750f52925c1d590f7f40f9f87a8a64cf92abf5b6148df39cf26"
    sha256 cellar: :any, arm64_linux:   "18959da7076fbccde29c438891894d146d4642810e0aa63fac6cfa4b38af33d9"
    sha256 cellar: :any, x86_64_linux:  "90274310299d89c75e4ec184f5d5266887e153b5c37a07a2209865384d08e4dc"
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
