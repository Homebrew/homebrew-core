class Py7zr < Formula
  include Language::Python::Virtualenv

  desc "7-zip in Python"
  homepage "https://github.com/miurahr/py7zr"
  url "https://files.pythonhosted.org/packages/f4/ca/f79d992febd1ab6cd4d51a98abda7e5bbf8a2b5399d05347a3993c0d63f7/py7zr-1.1.2.tar.gz"
  sha256 "2aee212c5516ddcbeb76874dc3ece38b4566fc003f51600032c723cfea89ac56"
  license "LGPL-2.1-or-later"
  head "https://github.com/miurahr/py7zr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "512ca004fa7a5233852a2ce5c1d346389999fc137b1e7d22e76a05426ec41637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0f3c6bc59d671f39e0699b510f47de2914e6571f2dbdf48292bd8082a79ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2bd932a1c3bcc66c6c8080aa86b76b32cd4f5f92338c9c7d96cf10ba67501a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "93b22c3c5b747e709f35fba1ab47db02792ad766cb3c595bb380eb75e50eb9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed79d4fe8efb6e16890f7d4fd3ce52adb63317ce4f7ff91536c4ae56f0d0bedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736d3eb7c4122879700be4fdb8a038b705c07d3423f82e9e80df9e1e41640593"
  end

  depends_on "python@3.14"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/12/0c/2670b672655b18454841b8e88f024b9159d637a4c07f6ce6db85accf8467/pybcj-1.0.7.tar.gz"
    sha256 "72d64574069ffb0a800020668376b7ebd7adea159adbf4d35f8effc62f0daa67"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/py7zr --version")

    (testpath/"test.txt").write("Homebrew")
    system bin/"py7zr", "c", "test.7z", "test.txt"
    rm testpath/"test.txt"
    assert_match "Everything is Ok", shell_output("#{bin}/py7zr t test.7z")
    system bin/"py7zr", "x", "test.7z"
    assert_path_exists testpath/"test.txt"
  end
end
