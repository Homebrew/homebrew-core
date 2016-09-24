class Mycli < Formula
  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://files.pythonhosted.org/packages/c7/12/782d85bd32dfa24a977dcc9a35b3cdd76b8cd33b58b78897f377d988f869/mycli-1.8.0.tar.gz"
  sha256 "7fe7c8fd06930009547fb44b9a4a143a0f8b7bd0911a31c5c2a29a76ba8e0021"

  bottle do
    cellar :any_skip_relocation
    sha256 "1483fd03ac596339762fd046087ea7018b49d7389070dd4fd3239cafa43a1578" => :sierra
    sha256 "326e6861074b6c541d0b13d487419995869b923030296a40de762359b43897aa" => :el_capitan
    sha256 "1816b49f2acd2aa4b8044acc0b631741ea812c006f0bcb1ab7c7d1a74939e615" => :yosemite
    sha256 "0326b74dc13b204ac10140da1296187f68442a35b7797a7ef8af0b3381986a4f" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "mycli" do
    url "https://files.pythonhosted.org/packages/c7/12/782d85bd32dfa24a977dcc9a35b3cdd76b8cd33b58b78897f377d988f869/mycli-1.8.0.tar.gz"
    sha256 "7fe7c8fd06930009547fb44b9a4a143a0f8b7bd0911a31c5c2a29a76ba8e0021"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/c0/d0/dcb9235c812b70f20d8d1ff110f9caa85daf4bf1ec2ac10516f51c07957e/prompt_toolkit-1.0.5.tar.gz"
    sha256 "b726807349e8158a70773cf6ac2a90f0c62849dd02a339aac910ba1cd882f313"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/f5/d9/976c885396294bb1c4ca3d013fd2046496cde2efbb168e4f41dd12552dd9/PyMySQL-0.7.6.tar.gz"
    sha256 "ad1115f1366c14a107f7b45c4a5f19b534f9ee85c188dfcd585fc08d2c966b30"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/9c/cc/3d8d34cfd0507dd3c278575e42baff2316a92513de0a87ac0ec9f32806c9/sqlparse-0.1.19.tar.gz"
    sha256 "d896be1a1c7f24bffe08d7a64e6f0176b260e281c5f3685afe7826f8bada4ee8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit pycrypto PyMySQL sqlparse Pygments wcwidth six configobj].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"mycli", "--help"
  end
end
