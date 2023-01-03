class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.4.0/jreleaser-1.4.0.zip"
  sha256 "0dd340f7ffde49d697c4fffacf884fe871a6af65753da0b1c71c77638d59113a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50b9016e0c96bead9f8383104c01f5b555e596540b751928d1a1dcc84bac39c5"
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
