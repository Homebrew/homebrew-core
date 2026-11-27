class PyenvPipMigrate < Formula
  desc "Migrate pip packages from one Python version to another"
  homepage "https://github.com/pyenv/pyenv-pip-migrate"
  url "https://github.com/pyenv/pyenv-pip-migrate/archive/refs/tags/v20181205.tar.gz"
  sha256 "c064c76b854fa905c40e71b5223699bacf18ca492547aad93cdde2b98ca4e58c"
  license "MIT"
  head "https://github.com/pyenv/pyenv-pip-migrate.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "c8039da2e210407f50e3d9cbf8f4b71d0924b11f08d8201a06525e178c6025d8"
    sha256 cellar: :any_skip_relocation, all: "22d0416340223bd3821c6f57f00515c5dff2d92772f0613dcd81ee13730fab6f"
  end

  depends_on "pyenv"

  deny_network_access!

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv help migrate")
  end
end
