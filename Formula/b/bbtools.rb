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
    sha256 cellar: :any,                 arm64_tahoe:   "530e2728af6ebfe135acbf52c1c82da2ad1617f80f2234a4458130f34da9a228"
    sha256 cellar: :any,                 arm64_sequoia: "abbf865aa13dfab020b72721d52ddc50864fdeef422e991e32747d7810016bdc"
    sha256 cellar: :any,                 arm64_sonoma:  "39ac42031c4f404dd7d3f9f15b0bc41c76c10ff6ad80dd51e1c07603b71d0169"
    sha256 cellar: :any,                 sonoma:        "0a5387a2da708b71b765bad7693681e8b3dc2cf1d430f35d62a5e4dfaa992b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56d0f92b22e0a3f21e2890a1bf226a79d39e8cb3cfd5930434b994df1c0f5f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9748716062e0a9d8fae3132f3de91fd6daea5379f565763c0da6ae3fef6d45c1"
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
