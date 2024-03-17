class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/4a/65/d187da76e65c358654a1bcdc4cbeb85767433e1e3eb67c473482301f2416/autopep8-2.1.0.tar.gz"
  sha256 "1fa8964e4618929488f4ec36795c7ff12924a68b8bf01366c094fc52f770b6e7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df75f5e7d87c112dc82690f9baa868ca441995a02e7513272b9fa50ce47e12e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2cfca46dd724324f0f262fe8e7db9d908d53fdd6d9956cea4addb3e13762d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fed09c7edba75caf54dd56a972c9350481f44079e8736add16c88ecc5287265d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6a60dcada346e0e4a7a9196f318c8aad382a9b2a290cae9e1e2d4caee6233f8"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf9a070e98f5347daae30fc905c7fabfc0930e9f9d083195725a27cf5d2ac67"
    sha256 cellar: :any_skip_relocation, monterey:       "49f67abbc72820d7792da308cb8ee426a0ea1691428ce6a34f5d88e2729c0b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acac2542bf513553db49344d6ad14cab2a79d776d2c1b116c239c8c7bc3487b8"
  end

  depends_on "python@3.12"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/34/8f/fa09ae2acc737b9507b5734a9aec9a2b35fa73409982f57db1b42f8c3c65/pycodestyle-2.11.1.tar.gz"
    sha256 "41ba0e7afc9752dfb53ced5489e89f8186be00e599e712660695b7a75ff2663f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
