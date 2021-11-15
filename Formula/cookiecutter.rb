class Cookiecutter < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates"
  homepage "https://github.com/cookiecutter/cookiecutter"
  url "https://files.pythonhosted.org/packages/58/f5/6f41fa38e6efe4a0e85771f99a4ad8c33b4c14f03b4cc53b459aac4a629a/cookiecutter-1.7.3.tar.gz"
  sha256 "6b9a4d72882e243be077a7397d0f1f76fe66cf3df91f3115dbb5330e214fa457"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/cookiecutter/cookiecutter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4ec359ec5071b56b351672f75a833d664952e6cb91fd2fd7af9eaa820bb4cc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c47bd026d10ec8f3c6267c689189abec6cdf90feb8879ddc498207d282219000"
    sha256 cellar: :any_skip_relocation, monterey:       "c48e22fb646e36938d0d5f7fe2679e9dde7a8edb8e92537f839e49c21e4f9bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db1b7554b40b410f51c337f60f6584cfe63f9d13764d6190976a7f83446aea9"
    sha256 cellar: :any_skip_relocation, catalina:       "ccaafe5436a8eb27c99c924b676de2601ca87413f9c980b6697e6144e32e5392"
    sha256 cellar: :any_skip_relocation, mojave:         "ffbc7736257952c954b380cc13a56c746cacb3991778d2a424eb0ab39129dc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295c5c1f199c24086400af1e87559a8affa98631a2d847883c3edebca2c47348"
  end

  depends_on "python@3.10"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/0a/97/e58a3cd2207cb9cb7aa9b91f3bc4df3b4e13eafc88d75b1a9f4535ea6e1f/arrow-1.1.0.tar.gz"
    sha256 "b8fe13abf3517abab315e09350c903902d1447bd311afbc17547ba1cb3ff5bd8"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/d5/99/286fd2fdfb501620a9341319ba47444040c7b3094d3b6c797d7281469bf8/click-8.0.0.tar.gz"
    sha256 "7d8c289ee437bcb0316820ccee14aefcb056e58d31830ecab8e47eda6540e136"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/0c/23cbcf515b5394e9f59a3e6629f26e1142b92d474ee0725a26aa5a3bcf76/Jinja2-3.0.0.tar.gz"
    sha256 "ea8d7dd814ce9df6de6a761ec7f1cac98afe305b8cdc4aaae4e114b8d8ce24c5"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/67/6a/5b3ed5c122e20c33d2562df06faf895a6b91b0a6b96a4626440ffe1d5c8e/MarkupSafe-2.0.0.tar.gz"
    sha256 "4fae0677f712ee090721d8b17f412f1cbceefbf0dc180fe91bab3232f38b4527"
  end

  resource "poyo" do
    url "https://files.pythonhosted.org/packages/7d/56/01b496f36bbd496aed9351dd1b06cf57fd2f5028480a87adbcf7a4ff1f65/poyo-0.5.0.tar.gz"
    sha256 "e26956aa780c45f011ca9886f044590e2d8fd8b61db7b1c1cf4e0869f48ed4dd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bc/a4/57893fbaf7cbf303a4f2307564cf83855a5f2cc34544656e7263125a0d1e/python-slugify-5.0.2.tar.gz"
    sha256 "f13383a0b9fcbe649a1892b9c8eb4f8eab1d6d84b84bb7a624317afa98159cab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "clone", "https://github.com/audreyr/cookiecutter-pypackage.git"
    system bin/"cookiecutter", "--no-input", "cookiecutter-pypackage"
    assert (testpath/"python_boilerplate").directory?
  end
end
