class PyenvPipMigrate < Formula
  desc "Migrate pip packages from one Python version to another"
  homepage "https://github.com/pyenv/pyenv-pip-migrate"
  url "https://github.com/pyenv/pyenv-pip-migrate/archive/88f09de2a06f95bd1933b950ec2b66671ae36fbd.tar.gz"
  version "20181205"
  sha256 "bd79295dd5412a6b90311e316e1b78553fc2c612dd6b4dec15cc030d7213fcfb"
  license "MIT"
  head "https://github.com/pyenv/pyenv-pip-migrate.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv help migrate")
  end
end
