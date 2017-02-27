class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.3.0"
  sha256 "2e60c7b6e93a5cd7d053e5a7ad91942d90931f7341e50a53a9f33943e5f60ea9"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4a77d3bae9077de0de12db93cdc041259fc9c29829ccbdbcd1067f493f1ffae0" => :sierra
    sha256 "12ffb789323a3afcab35a62e9a9b3a94dfe81d7ea0193bb9848529990850a0c0" => :el_capitan
    sha256 "3c4ebf5880732f8cd9a34577b27c5c99af3173345b4a55b893378aacc3cfbed7" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
