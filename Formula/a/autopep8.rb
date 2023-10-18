class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/e0/8a/9be661f5400867a09706e29f5ab99a59987fd3a4c337757365e7491fa90b/autopep8-2.0.4.tar.gz"
  sha256 "2913064abd97b3419d1cc83ea71f042cb821f87e45b9c88cad5ad3c4ea87fe0c"
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
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
