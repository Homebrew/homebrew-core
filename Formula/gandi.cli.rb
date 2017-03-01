class GandiCli < Formula
  include Language::Python::Virtualenv

  desc "command-line interface to Gandi.net products using the public API"
  homepage "http://cli.gandi.net"
  url "https://files.pythonhosted.org/packages/73/ae/f63bd762bdd0adb1bc0ad102076acf7e33f12b4ce4280a41fa0807b44f9b/gandi.cli-0.19.tar.gz"
  sha256 "0e8e1150f68c8921f279c629e6e7beaa4125d10c0d1990ede991fb0ceec928f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2afc3fbad32a5803e5418d34751ea960609be4d38f16d1a0f2cff4397cc5e6ca" => :sierra
    sha256 "874e57d20b0f53bd5c0cda268c48b69c53ba66df64091f8f0f206009b323af2b" => :el_capitan
    sha256 "b834f66d8c9d149306d4a7fb49a074f300077e7a3d64555d1930a94ebec1dd58" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/88/99/293dac0b3cdf58ce029ec5393624fac5c6bde52f737f9775bd9ef608ec98/appdirs-1.4.2.tar.gz"
    sha256 "e2de7ae2b3be52542b711eacf4221683f1d2f7706a5550cb2c562ee4ba93ee74"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "IPy" do
    url "https://files.pythonhosted.org/packages/88/28/79162bfc351a3f1ab44d663ab3f03fb495806fdb592170990a1568ffbf63/IPy-0.83.tar.gz"
    sha256 "61da5a532b159b387176f6eabf11946e7458b6df8fb8b91ff1d345ca7a6edab8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_create(libexec, "python")
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gandi", "--version"
  end
end
