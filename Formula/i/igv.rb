class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://igv.org/doc/desktop/"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.18/IGV_2.18.4.zip"
  sha256 "d60870e27db0ba22278df3bcfb6113c1adc86b940f02d754983c91688d3a0fae"
  license "MIT"

  livecheck do
    url "https://igv.org/doc/desktop/DownloadPage/"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb216357c28ddab5510cd2316993a61b4d36f2ca509eb1b4ee6db960113cce9b"
  end

  depends_on "openjdk"

  def install
    inreplace ["igv.sh", "igvtools"], /^prefix=.*/, "prefix=#{libexec}"
    bin.install "igv.sh" => "igv"
    bin.install "igvtools"
    libexec.install "igv.args", "lib"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/igvtools")
    assert_match "org/broad/igv/ui/IGV.class", shell_output("#{Formula["openjdk"].bin}/jar tf #{libexec}/lib/igv.jar")

    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    (testpath/"script").write "exit"
    assert_match "Using system JDK.", shell_output("#{bin}/igv -b script")
  end
end
