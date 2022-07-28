class JacocoCli < Formula
  desc "JaCoCo Java Code Coverage Library Command-line"
  homepage "https://github.com/jacoco/jacoco"
  url "https://search.maven.org/remotecontent?filepath=org/jacoco/org.jacoco.cli/0.8.7/org.jacoco.cli-0.8.7-nodeps.jar"
  sha256 "11b549a9ef14d8454534f914ca1051fb9bcacab7f501e9f1c018eacfc5e77e8d"
  license "EPL-2.0"

  depends_on "openjdk@11"

  def install
    libexec.install "org.jacoco.cli-0.8.7-nodeps.jar"
    bin.write_jar_script libexec/"org.jacoco.cli-0.8.7-nodeps.jar", "jacoco-cli"
  end

  test do
    assert_match "0.8.7.202105040129", shell_output("#{bin}/jacoco-cli version")
  end
end
