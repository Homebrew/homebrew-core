class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.14.0/jreleaser-1.14.0.zip"
  sha256 "9ffaae7cef052bc01415f47865f6fe3cccef7e470527eaaf5d3c0245f36acba9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "546f8acf4e3c414f2fda40fac84fff15e5b503173d433d6dedd090353cfc9f16"
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
