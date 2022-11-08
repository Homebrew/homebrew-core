class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.15/IGV_2.15.2.zip"
  sha256 "54b45973fac8f1fc610e6bca3de58ebd5a6988a1e62b65bd0461eac55c7ff830"
  license "MIT"

  livecheck do
    url "https://software.broadinstitute.org/software/igv/download"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26bbbaa1478193f90731fa51acefed3501f7d4fdf0b9787041f5631ae6edd81f"
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
