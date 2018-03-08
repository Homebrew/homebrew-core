class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://github.com/hhatto/autopep8/archive/v1.3.4.tar.gz"
  sha256 "4d6c88bae7f008c70201d0178ed40c3bca9a63a4ad8ecceb69bf8b952dc86a1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ab913aa82b2ea9906a2578c3346aaf0f455320e4b80644112b1b56dfcc90234" => :high_sierra
    sha256 "e0b3f83d42e8dae3d8acce34fb58a10d05c85ef0df4ef39a7d2392223d43ca89" => :sierra
    sha256 "3a0c5883c51beb734c5a50e27f5b97cf1baae9f8b33dd516cc56401b3c7999ef" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
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
