class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.27/kumo-cli-1.27.jar"
  sha256 "f3643a734e6f8d9c31b0a50f7d4df3f99ea0bf81377efd5a79291b2fff51f1e6"

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
