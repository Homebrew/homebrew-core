class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.27.0/jreleaser-1.27.0.zip"
  sha256 "3e9b9131ad4e8445b007c234d219ea09482f59aaeb891b12bfec4e16c7cdfa44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3b7eba99eb1e27608a48b092004a7f3a6ddda5344d096a41729a422ee7caa6a"
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
