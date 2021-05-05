class Faunus < Formula
  include Language::Python::Virtualenv

  desc "Framework for Metropolis Monte Carlo Simulation of Molecular Systems"
  homepage "https://mlund.github.io/faunus"
  url "https://github.com/mlund/faunus/archive/522213d.zip"
  version "2.5.0"
  sha256 "5872d39ac3e3eab6069031ea966374ddc31a989ca4223ceb97f8a8da3b5b49f5"
  license "MIT"
  revision 1

  depends_on "cmake" => :build
  depends_on "python@3.9"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end
  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end
  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/9a/ee/55cd64bbff971c181e2d9e1c13aba9a27fd4cd2bee545dbe90c44427c757/ruamel.yaml-0.15.100.tar.gz"
    sha256 "8e42f3067a59e819935a2926e247170ed93c8f0b2ab64526f888e026854db2e4"
  end

  def install
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resources
    system "cmake", "-DENABLE_OPENMP=off", "-DENABLE_PYTHON=on", "-S", ".", *std_cmake_args,
      "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
    system "make", "install"
  end

  test do
    system "#{bin}/faunus", "--version"
    system "#{bin}/yason.py", "-h"
  end
end
