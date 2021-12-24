class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.11/IGV_2.11.9.zip"
  sha256 "9a5b5861be38c653cf7402817a1b068e8f65a1090de2d9dffb28872f05a8ac99"
  license "MIT"

  livecheck do
    url "https://software.broadinstitute.org/software/igv/download"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcf7aceaffdb6a6c6c9d8d4e791616783362b3ad50a9382dd3d3bf5a220a9330"
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
