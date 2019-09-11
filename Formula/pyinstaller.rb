class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/e2/c9/0b44b2ea87ba36395483a672fddd07e6a9cb2b8d3c4a28d7ae76c7e7e1e5/PyInstaller-3.5.tar.gz"
  sha256 "ee7504022d1332a3324250faf2135ea56ac71fdb6309cff8cd235de26b1d0a96"

  head "https://github.com/pyinstaller/pyinstaller.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e24fb59052ce51b1ad9c77b2a5cb7fef1430f2c09ae85c129b00469ab4cf31c3" => :mojave
    sha256 "45e50e7a2fdca28463bb9d5f3785fb11a62f73a9dfea88fc1e0584539b5871a1" => :high_sierra
    sha256 "4112b5a32d0b465156e207d08f8c97512625df9e2ee3596cd27dbf8ae7a63ffd" => :sierra
  end

  depends_on "python"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/da/a4/6c508ac94d7a65859a7a47e6fbde4aa6b81d0f0863aa45861241e782391c/altgraph-0.16.1.tar.gz"
    sha256 "ddf5320017147ba7b810198e0b6619bd7b5563aa034da388cea8546b877f9b0c"
  end

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/da/a4/6c508ac94d7a65859a7a47e6fbde4aa6b81d0f0863aa45861241e782391c/altgraph-0.16.1.tar.gz"
    sha256 "ddf5320017147ba7b810198e0b6619bd7b5563aa034da388cea8546b877f9b0c"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/72/60/2b22bef6edfb2864f7c0dc1d55b75e70ba1c3670899bead37e059e29b738/macholib-1.11.tar.gz"
    sha256 "c4180ffc6f909bf8db6cd81cff4b6f601d575568f4d5dee148c830e9851eb9db"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/ed/cc/157f20038a80b6a9988abc06c11a4959be8305a0d33b6d21a134127092d4/pefile-2018.8.8.tar.gz"
    sha256 "4c5b7e2de0c8cb6c504592167acf83115cbbde01fe4a507c16a1422850e86cd6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build", libexec/"lib/python#{xy}/site-packages/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
