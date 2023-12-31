class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/ba/5c/b6bc3583a01c11ccf205bfe3a10d46f20de0645e5cbd613881b320d00b80/coconut-3.0.4.tar.gz"
  sha256 "106f092f91e6cf509415cc627bf52ecda71a065158614cbfe73fa73dceeed98a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80bf34059fd3cee8c1393d0ece31ce292978699db9fb2cf82c217a96a624ed43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f754ba17cc05181a861d530581ac333be8cdccfca16b0d1c7974e93f544a2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "874465dd4f0811b9fa2af6094c321c9e004a1b425dc7f8d0706b4f2b350ebb02"
    sha256 cellar: :any_skip_relocation, sonoma:         "48d03fd41c2cc9408040f263627b358304c61de8f3f81eff3be71bcf7bd46948"
    sha256 cellar: :any_skip_relocation, ventura:        "c2483568dcc235a3f2039c4e9c2573a5eccb576cb3a2a0ea919d26deb4b85368"
    sha256 cellar: :any_skip_relocation, monterey:       "72470db368dd6bc87a35522ae59123ef96abe088957535dc44ba0466da0b4f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1044c538a997eb4c56cb07bf8f6dd1260198506f646aa7fe0cdf0ba77ae24f5e"
  end

  depends_on "pygments"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/f1/2c/be67465b34206c24be7230746f589f0d4adbb60f96e889fc248fd51b9e3d/cPyparsing-2.4.7.2.3.2.tar.gz"
    sha256 "746c6a780f7e64dc717ac1cc28ffbab7841df0672cad851d26cf15faa11a4692"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
