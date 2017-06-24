class IpythonAT5 < Formula
  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/21/86/58d06db0c82af66c2d47faead027c3ce775cfbf9bc9d2f13f85d95f0a162/ipython-5.4.1.tar.gz"
  sha256 "afaa92343c20cf4296728161521d84f606d8817f963beaf7198e63dfede897fb"
  revision 1
  head "https://github.com/ipython/ipython.git", :branch => "5.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "2acce5ad0cdf5e9de01e685aa91b40d9cdc9bd2295fafd6e011ccbc424d6591b" => :sierra
    sha256 "23f82ddbe0fc67badbf7f255fdbd46cfec4297e371edc44b2b60f8e68a7a4f12" => :el_capitan
    sha256 "a65a771f84259592ad67d43097aa22e7a7b614b3d3b8dc79800efe9eb06b52f0" => :yosemite
  end

  keg_only :versioned_formula

  depends_on :python

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/0c/41/67e16b243b78b49f4b1650d045b63be187c27d20a76f0f7b8e61e0fcb966/ipykernel-4.6.1.tar.gz"
    sha256 "2e1825aca4e2585b5adb7953ea16e53f53a62159ed49952a564b1e23507205db"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jupyter_client" do
    url "https://files.pythonhosted.org/packages/d4/51/09da9a18cd858b28cee596a628660a8cbf9830bdd89fe94361bfe18a0bb4/jupyter_client-5.1.0.tar.gz"
    sha256 "08756b021765c97bc5665390700a4255c2df31666ead8bff116b368d09912aba"
  end

  resource "jupyter_core" do
    url "https://files.pythonhosted.org/packages/2f/39/5138f975100ce14d150938df48a83cd852a3fd8e24b1244f4113848e69e2/jupyter_core-4.3.0.tar.gz"
    sha256 "a96b129e1641425bf057c3d46f4f44adce747a7d60107e8ad771045c36514d40"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/a1/14/df0deb867c2733f7d857523c10942b3d6612a1b222502fdffa9439943dfb/pathlib2-2.3.0.tar.gz"
    sha256 "d32550b75a818b289bd4c1f96b60c89957811da205afcceab75bc8b4857ea5b3"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/69/fe/dd137d84daa0fd13a709e448138e310d9ea93070620c9db5454e234af525/pickleshare-0.7.4.tar.gz"
    sha256 "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/55/56/8c39509b614bda53e638b7500f12577d663ac1b868aef53426fc6a26c3f5/prompt_toolkit-1.0.14.tar.gz"
    sha256 "cc66413b1b4b17021675d9f2d15d57e640b06ddfd99bb724c73484126d22622f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/51/83/5d07dc35534640b06f9d9f1a1d2bc2513fb9cc7595a1b0e28ae5477056ce/ptyprocess-0.5.2.tar.gz"
    sha256 "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/af/37/8e0bf3800823bc247c36715a52e924e8f8fd5d1432f04b44b8cd7a5d7e55/pyzmq-16.0.2.tar.gz"
    sha256 "0322543fff5ab6f87d11a8a099c4c07dd8a1719040084b6ce9162bcdf5c45c9d"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/bd/f4/3143e0289faf0883228017dbc6387a66d0b468df646645e29e1eb89ea10e/scandir-1.5.tar.gz"
    sha256 "c2612d1a487d80fb4701b4a91ca1b8f8a695b1ae820570815e85e8c8b23f1283"
  end

  resource "simplegeneric" do
    url "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"
    sha256 "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/df/42/a180ee540e12e2ec1007ac82a42b09dd92e5461e09c98bf465e98646d187/tornado-4.5.1.tar.gz"
    sha256 "db0904a28253cfe53e7dedc765c71596f3c53bb8a866ae50123320ec1a7b73fd"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"
    sha256 "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # install other resources
    ipykernel = resource("ipykernel")
    (resources - [ipykernel]).each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install and link IPython
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install libexec/"bin/ipython"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # install IPython man page
    man1.install libexec/"share/man/man1/ipython.1"

    # install IPyKernel
    ipykernel.stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # install kernel
    system libexec/"bin/ipython", "kernel", "install", "--prefix", share
    inreplace share/"share/jupyter/kernels/python2/kernel.json", "]", <<-EOS.undent
      ],
      "env": {
        "PYTHONPATH": "#{ENV["PYTHONPATH"]}"
      }
    EOS
  end

  def post_install
    (etc/"jupyter/kernels/python2").install Dir[share/"share/jupyter/kernels/python2/*"]
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print 2+2'").chomp

    system bin/"ipython", "kernel", "install", "--prefix", testpath
    assert_predicate testpath/"share/jupyter/kernels/python2/kernel.json", :exist?, "Failed to install kernel"
  end
end
