class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/99/02/1f0f5e6ec82d22bb7c68b699d626f46a41d05f8e32269b2543348d345734/pipdeptree-2.3.3.tar.gz"
  sha256 "9d666f77ff1b9528d01b3d98594096484f56de70d752abe22f13e681be239bd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb4b64902672bb9c99e81a6b5cc509179a830c767844488e232cb1ab31c1358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef92a2133e740478a66a1285c865bdaa21224a4bbaa5bc8f1d66a3cd9dc8dc34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3535cee7a899a0c0307d4b92f13c39c32455dfdfdbce1b1f1465d2f6e0919c85"
    sha256 cellar: :any_skip_relocation, ventura:        "24f53d298b6187f4aa1136d985de2c90bd41a7e96d6c6351bf28204d7c0e92fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b62ddbd6bad99f0ef0b71361aa00cd854c036738bf49a529e645ab86a14ca85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff3a62a3a8306edd6c55b104c0126589baba3a0199c0dcf713a7455e6faba606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea0e6e640705a8cc5533094c48b0ef306298285c3f245ee762cddeb4330636e"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
