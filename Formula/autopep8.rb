class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/12/55/7b07585ca0c30e5b216e4d627f82f96f1a7e82d2dd727b1f926cb3f3d58b/autopep8-1.5.tar.gz"
  sha256 "0f592a0447acea0c2b0a9602be1e4e3d86db52badd2e3c84f0193bfd89fd3a43"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd453270ef227061e272f5756aff21d21c9581204144a46903f71cd673181e85" => :catalina
    sha256 "f20261fb78a887b3c30a55ae517547b5d6d9c8a1d82a7bbfa04613db0649be16" => :mojave
    sha256 "1bcfa4d6f774c8c945c8519985138a94b639937bc8f2efe12eb397f8a2bbf5df" => :high_sierra
    sha256 "c4df65a7a34991e0f1bfaeb567621592e9f8f50f047f562d7044a9badc067798" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
