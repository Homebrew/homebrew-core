class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.22.0/jreleaser-1.22.0.zip"
  sha256 "e4355b24942c8bbd9afb26426ec1a930a4412d3856e96bac007b3d6a9e76b29c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce3eca32ee4e9c496304f2802766c91c93dcfd08f998398a46c3641a5c68986b"
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
