class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.28/kumo-cli-1.28.jar"
  sha256 "43e4e2ea9da62a2230deed9151d8484f80bd6ae5fef304eaadf3301378f45fb6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "596af3ddc1bc9b8881fbc386ae85804fe999cee118a99fc13e123db2c5acefe1"
  end

  depends_on "openjdk"

  def install
    libexec.install "kumo-cli-#{version}.jar"
    bin.write_jar_script libexec/"kumo-cli-#{version}.jar", "kumo"
  end

  test do
    system bin/"kumo", "-i", "https://wikipedia.org", "-o", testpath/"wikipedia.png"
    assert_predicate testpath/"wikipedia.png", :exist?, "Wordcloud was not generated!"
  end
end
