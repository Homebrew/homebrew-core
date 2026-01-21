class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.61.tar.gz"
  sha256 "044522b02eb2f1c2ca271babf5e36cfd31cbf817cb3f1e9d79d0a57b3779a2d6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7facada6f63e1c2fb12557c1e38c9d1e7e89d4315ffb3c19e55cd2247dfcb57"
    sha256 cellar: :any,                 arm64_sequoia: "a88c6f1ec1adf73b7eacba5f8b6d49a91941ce57bbf1c407b629bbe076932e50"
    sha256 cellar: :any,                 arm64_sonoma:  "dc00ca27e2a9de42b9a75415ca0ed6147c3adeec2ceb05e2e973dcfec5ddce56"
    sha256 cellar: :any,                 sonoma:        "2d5cd755a09f2719ac421c1d11f4d8fb7b79430e409d8af5ccc8fa4f94120bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa184f336a79a8b6e6f98a67d0251373e9e63f58395d174cb853718afc5870a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8029f63484a18e69382318f12a169c4b30eca18e921e5b90ae2b0ee035f6483e"
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
