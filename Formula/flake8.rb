class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.6.0"
  sha256 "c19a9954dd8121ace467d605e63188dad7ce34b77a1e8dfc7c4d967016a85bd6"
  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "c920e57f095a6a1e068e2092850fe8e55cf5e0c5f91bd6891f23718e584ebe09" => :mojave
    sha256 "24b99c8d674b9cdd6da35e580fc989aeb02f5ef646d2555665f688f3e57df334" => :high_sierra
    sha256 "878f83596f0c3d781b2ab9f6f2f1c94a3b77984b3ac78bf4e704b8af0bb59220" => :sierra
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
    xy = Language::Python.major_minor_version "python3"
    # flake8 version 3.6.0 will fail this test with `E203` warnings.
    # Adding `E203` to the list of ignores makes the test pass.
    # Remove the customized ignore list once the problem is fixed upstream.
    system "#{bin}/flake8", "#{libexec}/lib/python#{xy}/site-packages/flake8", "--ignore=E121,E123,E126,E226,E24,E704,W503,W504,E203"
  end
end
