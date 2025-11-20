class PyenvPipMigrate < Formula
  desc "Migrate pip packages from one Python version to another"
  homepage "https://github.com/pyenv/pyenv-pip-migrate"
  url "https://github.com/pyenv/pyenv-pip-migrate/archive/refs/tags/v20181205.tar.gz"
  sha256 "c064c76b854fa905c40e71b5223699bacf18ca492547aad93cdde2b98ca4e58c"
  license "MIT"
  head "https://github.com/pyenv/pyenv-pip-migrate.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "22d0416340223bd3821c6f57f00515c5dff2d92772f0613dcd81ee13730fab6f"
  end

  depends_on "pyenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv help migrate")
  end
end
