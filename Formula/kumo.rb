class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.17/kumo-cli-1.17.jar"
  sha256 "17f84d6287eeccf361c9eabe6d7449983c13d777afd161105a324c00adcadd0e"
  revision 1

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
