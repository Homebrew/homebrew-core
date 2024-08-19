class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/63/37/8f5ee72905948757f284e7a4fea1cd8b7203f13e57d2cf4917f2f1afa7a8/mackup-0.8.41.tar.gz"
  sha256 "49f929d502b3efbc01b5a206af6cff877447ac5821591b2a9231cbf42d97b17a"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  # see discussions in https://github.com/lra/mackup/issues/2035,
  # https://github.com/lra/mackup/issues/1924,
  # and https://github.com/lra/mackup/discussions/1969#discussioncomment-8485995
  deprecate! date: "2024-08-19", because: "Potential data loss on MacOS 14 (Sonoma) when using backup or restore command"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, ventura:        "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, monterey:       "dac4b2e6a5dbb4b99eeb476ca7a80d7b313dab3f733474ab24c6ad02bee7637e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcad6afdb1201c9d64101252384cb1d5b61b5430cf5deabd184510d84f6b6da"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mackup", "--help"
  end
end
