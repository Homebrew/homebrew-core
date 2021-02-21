class PyenvPipMigrate < Formula
  desc "Migrate pip packages from one Python version to another"
  homepage "https://github.com/pyenv/pyenv-pip-migrate"
  url "https://github.com/pyenv/pyenv-pip-migrate/archive/v20181205.tar.gz"
  sha256 "c064c76b854fa905c40e71b5223699bacf18ca492547aad93cdde2b98ca4e58c"
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
