class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.5.1/jreleaser-1.5.1.zip"
  sha256 "d13384f83a16526ea0c4ef4d5e4f9d637b7100ddd470a637ac361245151c8340"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a74632b4ed4d2f8f5e8955f584ae1b1e2fc490cdf67827e09f4c25656b031f48"
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
