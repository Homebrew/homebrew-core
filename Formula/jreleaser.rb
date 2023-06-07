class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.6.0/jreleaser-1.6.0.zip"
  sha256 "58a0593ecce9e2acad2851374d24dc8180bfbe6dfe48de35a1d1ba75747df1b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f59d450df15e7056a0e13cf171b1d2f3726d86c732ba463d2e4173909443ffd"
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
