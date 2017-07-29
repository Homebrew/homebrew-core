class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.4.1"
  sha256 "8b87cc3b8ad6b11b1738ac2f40c648ff88f3a810d0a323389bb635c1f8f55b3f"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e98b0fea0977142ae2bacb84de845865b623cb77eb3e820018d49ea7864044f5" => :sierra
    sha256 "5dc5fed1566eaaefe298b8a5e17148ccaf90d9a1f0b64a87a1c697e71cfab0ac" => :el_capitan
    sha256 "58e4bd24292d4ca2247e8088b457357b0b296d8831d09e0199a26a6e79f348a2" => :yosemite
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
