class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://software.broadinstitute.org/software/igv/"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.16/IGV_2.16.1.zip"
  sha256 "9529dcc698310d7fe62da859df07e7876afdffe4a56be871e3e54aa93ef98d64"
  license "MIT"

  livecheck do
    url "https://software.broadinstitute.org/software/igv/download"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9d68e93d1e5ae94bc3b9dc96ccb29410b1107f91dd1d32b08fa9e31bbf37d96"
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
