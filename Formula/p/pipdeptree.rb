class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/f1/22/af4f7e301cf70dc5ecb6f25366122f3925637013376971e2356ebde82695/pipdeptree-2.16.2.tar.gz"
  sha256 "96ecde8e6f40c95998491a385e4af56d387f94ff7d3b8f209aa34982a721bc43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8ab079473679c1a0efa884091f9e278c427fcf1eddced097480fbe266cd112"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, ventura:        "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd67fdc0e38e2ce7e70f7a53c5def58238e12ea7e2296b413cb62d3b80fd27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a795130ee233c5e675fcd22bcc6009167d56945dd00d01a5cda9206fc6a529a0"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
