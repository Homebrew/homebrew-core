class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.5.0"
  sha256 "97ecdc088b9cda5acfaa6f84d9d830711669ad8d106d5c68d5897ece3c5cdfda"
  revision 1
  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "7dfcf70ad656073cd15198c441148de0ebb50c27912398d03853dda243f69597" => :mojave
    sha256 "75c0b3b214915fea67ac8633d5daafe404e1775a0a46b27bc2fc4e9878ae8490" => :high_sierra
    sha256 "854cb1e3303bbd1e90ece8e512c21ca872fd1d2f6038ca1a4ba27e109991554f" => :sierra
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
    system "#{bin}/flake8", "#{libexec}/lib/python#{xy}/site-packages/flake8"
  end
end
