class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.19.0/jreleaser-1.19.0.zip"
  sha256 "5a20df93b51654f6a06984a587e4c3595f5746b95f202b571d707315a2191efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ff7087834c1a232b18543dcd6ea4deb9ef4ea6e93de38bc64a408dc3028d06b"
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
