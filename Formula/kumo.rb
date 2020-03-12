class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.22/kumo-cli-1.22.jar"
  sha256 "5a4aebd6074a0dd4ae493380a54b96f9b571446673fd82c764ed0b9f37511cab"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "kumo-cli-#{version}.jar"
    (bin/"kumo").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/kumo-cli-#{version}.jar" "$@"
    EOS
  end

  test do
    system bin/"kumo", "-i", "https://wikipedia.org", "-o", testpath/"wikipedia.png"
    assert_predicate testpath/"wikipedia.png", :exist?, "Wordcloud was not generated!"
  end
end
