class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.26.0/jreleaser-1.26.0.zip"
  sha256 "c821df22b1715a841024ba17c4b5233375c868e6c9dcc81612c38329c8dec628"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "114cdfaf9806a10c2780f5ca95257c8fca16079dcbfb62f59a0577a9f718efa3"
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
