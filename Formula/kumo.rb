class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.13/kumo-cli-1.13.jar"
  sha256 "c9ad525f7d6aec9e2c06cf10017e1e533f43b1b3c4df5aa0d4b137f8d563c5c6"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "kumo-cli-#{version}.jar"
    bin.write_jar_script libexec/"kumo-cli-#{version}.jar", "kumo"
  end

  test do
    system bin/"kumo", "-i", "https://wikipedia.org", "-o", testpath/"wikipedia.png"
    assert_predicate testpath/"wikipedia.png", :exist?, "Wordcloud was not generated!"
  end
end
