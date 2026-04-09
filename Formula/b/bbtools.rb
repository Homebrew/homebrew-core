class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.81b.tar.gz"
  sha256 "e0beee3a7683812833a9fa797f63151d96a4cdb5ff90961dcba537d541ea8572"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "158b606f7c3445fd8d92c11c96b50e56e79d051facde08c560e60b1db2af9e1d"
    sha256 cellar: :any,                 arm64_sequoia: "2994ed978730d312f9116d1aba5613aa56455dd7b35aeeb5d9aa6f9e52f2bf4c"
    sha256 cellar: :any,                 arm64_sonoma:  "fe75263d60ccce3c1f109e00df664c048b3e09cd55e2daf37a54a1b1c1fd7175"
    sha256 cellar: :any,                 sonoma:        "9661596562639d4000ce9a08f5484b2c07ba24e88a7e50212087674ddb671b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043d40e6da243f093d41d1b72fd0f231e17a2f7197f085d38a28692a134ba223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4371a3644753bdb11b5da20c2ced08cc0ad6929ff9ef9b67b590d8bafa9bd9"
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
