class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.21.tar.gz"
  sha256 "205132a4249c26c239878658d0f23c68190656c7f76f061e2d8c3e8f82e29e2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2e733a2ecbc08634873e65f4c60fbdfe31e199f41bfb1052cd9001ca62b665e"
    sha256 cellar: :any,                 arm64_sonoma:  "528058cfa025ddd75ce796f7df4d0bfa5ff41143ecfd14b20d66c0bc8839a04a"
    sha256 cellar: :any,                 arm64_ventura: "fbfce92710db4a0afe9dadecd5f29b189d37da14e08359885ae229633e56fe99"
    sha256 cellar: :any,                 sonoma:        "b70f555ebe40774f152f2f4ac33528fc6f4b3a050e7f4a6c5e6ea87b31eefc43"
    sha256 cellar: :any,                 ventura:       "4dec8f95e6723eb4921473d15ec706964eedc3e14ab7a97a0cecf671189ecb37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d7401a4edfb27d06ac2ac5ca3dcc9684ab6ce17db3d045b91d6131aa8a9b80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0521e7706b647e9f6f05d76ba9a11d23d18809251fb85a52dba4ae1e530b2876"
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
