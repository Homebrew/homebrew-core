class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://igv.org/doc/desktop/"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.19/IGV_2.19.9.zip"
  sha256 "733131d4537c7158b23c976cb57f2490afd609fc38153f4861bef88a36edf105"
  license "MIT"

  livecheck do
    url "https://igv.org/doc/desktop/DownloadPage/"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    manifest_sha256 "a51ddcd31270cc3c0711b17cd2916fca9b5fef5289f17718efc2e9d3099e3866"
    sha256 cellar: :any_skip_relocation, all: "b2d2b5c38a920402b544c060eefe0ec44bf5750ffe58b1b588769d9d276398b9"
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
    assert_match "org/broad/igv/ui/IGV.class",
      shell_output("#{formula_opt_bin("openjdk")}/jar tf #{libexec}/lib/igv.jar")

    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    (testpath/"script").write "exit"
    assert_match "Using system JDK.", shell_output("#{bin}/igv -b script")
  end
end
