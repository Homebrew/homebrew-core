class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.10.0/jreleaser-1.10.0.zip"
  sha256 "a3dc16afe344d888b8fd9548d082c69b05e393da50e4991f5e3da30c9d78164c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b01cc1835922d7f9c41a490cd8739cf878a6c03e8d80fc0b82281a2831c1631"
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
