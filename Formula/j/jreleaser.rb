class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.23.0/jreleaser-1.23.0.zip"
  sha256 "69232072d4c8ed71fd579211c38a6dd25c5a10b9b6cbd70bcaf2117fc5c2ed61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5cbbaa4f914e6605da9e5b0c18c1388ecfbc15d5257dc092b9c4d3db01770cf"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end
