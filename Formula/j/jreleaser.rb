class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.21.0/jreleaser-1.21.0.zip"
  sha256 "5d126a7e7f8e8b973832fae83aa3938fbfef4ae17432573be410691c96a4f073"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1508bb5f55c2f62bbccb3ca6aa93c7ea66274b24e6408d270e0765eae035854f"
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
