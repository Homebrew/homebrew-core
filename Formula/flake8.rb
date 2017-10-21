class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.5.0"
  sha256 "97ecdc088b9cda5acfaa6f84d9d830711669ad8d106d5c68d5897ece3c5cdfda"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5183704dc1be1eb7b69a799332701b3537dcd344cc1da5efb1a8c6d10c4f1d23" => :high_sierra
    sha256 "52247f453420402adf92473646822df170eba8988869408536758a9dca3cf02a" => :sierra
    sha256 "7cedbefbd6364386eaed992f81cfeb1dfca08997bda82e59d726a247d6fd6dea" => :el_capitan
    sha256 "867901db2671873cfdbaec243d6a7e13f8fcc9e61b3b7f6353b7d9142c52c874" => :yosemite
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
