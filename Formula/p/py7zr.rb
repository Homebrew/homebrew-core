class Py7zr < Formula
  include Language::Python::Virtualenv

  desc "7-zip in Python"
  homepage "https://github.com/miurahr/py7zr"
  url "https://files.pythonhosted.org/packages/97/62/d6f18967875aa60182198a0dd287d3a50d8aea1d844239ea00c016f7be88/py7zr-1.0.0.tar.gz"
  sha256 "f6bfee81637c9032f6a9f0eb045a4bfc7a7ff4138becfc42d7cb89b54ffbfef1"
  license "LGPL-2.1-or-later"
  head "https://github.com/miurahr/py7zr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02da521b47f7f8947c63b64a6344054b49c030ae9d9b267dcc1f46196ac465b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dfa9479719f8c0271aed5d34f305b0f0cd4d169bd7d70a868a79123152ea687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60c530c0945439a23240b325ce941c1473d77668eaacd83f5ab13a42dc39d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9f82f2e1a078061d9ba1b77fa6fa593af2f73436f3497230053a1775423802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0427b82540823f8277aa2ca891a396570f10a5e39da9e6854972ebc703346e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d895e0a0fcebf5f927c0e2eff5d047211aa6024699275971bb6398031068e7"
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
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
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
    url "https://files.pythonhosted.org/packages/f6/d7/b3084ff1ac6451ef7dd93d4f7627eeb121a3bed4f8a573a81978a43ddb06/pyppmd-1.2.0.tar.gz"
    sha256 "cc04af92f1d26831ec96963439dfb27c96467b5452b94436a6af696649a121fd"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/47/82/7bcafbf06ee83a66990ce5badbb8f4dc32184346bab20de7e468b1a2f6ec/pyzstd-0.18.0.tar.gz"
    sha256 "81b6851ab1ca2e5f2c709e896a1362e3065a64f271f43db77fb7d5e4a78e9861"
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
