class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.13.1/jreleaser-1.13.1.zip"
  sha256 "c384888b61fd99ba3a3d3366a20ca5bb63e6ec054eb2841490ede5762d87ae59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, monterey:       "d5cb09a9ecf14b9d5e6fe986996808ebfd04295042b72615b67df5c145f90381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adbfa52d246f5b0dd5eb1cac286534a613ae2b6812fffb1fb47c5489dcb0573b"
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
