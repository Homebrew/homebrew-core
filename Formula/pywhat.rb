class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ae/31/57bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81/pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480ba6a8c42429fac58f689d10953189fafc5e6d88af1c89cf40b1cf9615206d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac74f058deb4625e95ac54d69abd24d2070d5e661bc07037706d330f88fac05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "696e78d8044c155ad0953148b89a7e8d0f89c385b73452a0129b8db3ac8737e5"
    sha256 cellar: :any_skip_relocation, ventura:        "a1843a509d2a5357beef1cae3b19387269868ed276d743520b94ba799c724fde"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7fa1694ce65ed22d9aeb7ef7e853f06094049c2a2af5b0d04507ee452cccc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "97bfac5197c7b3f4af650b1862b8e3675797fecb70568154488ca27bf47aabb3"
    sha256 cellar: :any_skip_relocation, catalina:       "11521a3f937f546818b64f33f369d6a748056853ce71f32aff13fdf0246fe938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e175c03515ec4cb1c538c1989cabbc52686ac198969c4d545a218ef6be190808"
  end

  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/c3/e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093/rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
