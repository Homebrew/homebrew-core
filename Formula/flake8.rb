class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.5.0"
  sha256 "97ecdc088b9cda5acfaa6f84d9d830711669ad8d106d5c68d5897ece3c5cdfda"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "929140b14958e23321f395143c3ef31166f344058fdbaac843deca1a94b48782" => :high_sierra
    sha256 "825dd5873edf54a9acbf35daa908559b4323f27e6800401d097217d9db28128c" => :sierra
    sha256 "cfbc382496c31b5c57e31ac2487d022a07673d9efd2d64cbc956d3e05c8d9afe" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/flake8", "#{libexec}/lib/python2.7/site-packages/flake8"
  end
end
