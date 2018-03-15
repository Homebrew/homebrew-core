class Jupyter < Formula
  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/c9/a9/371d0b8fe37dd231cf4b2cff0a9f0f25e98f3a73c3771742444be27f2944/jupyter-1.0.0.tar.gz"
  sha256 "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f"
  revision 3

  bottle do
    cellar :any
    sha256 "950f7e3399bc3668916b5634e2067d106e5206c0b452db13e89b9dcae781fc23" => :high_sierra
    sha256 "8b868ac865e4005b3b7c7f7912fed224c4f25613a83b6194b40113a333e92ad6" => :sierra
    sha256 "1708125f0ae94cec7d5f5dff0e8353209933eb594b3733b80fe6f0b37f6fd55b" => :el_capitan
  end

  option "with-qtconsole", "Install with Qtconsole"
  option "without-console", "Install without Jupyter Console"
  option "without-nbconvert", "Install without Nbconvert"
  option "without-notebook", "Install without Jupyter Notebook"

  depends_on "ipython@5"
  depends_on "python@2"
  depends_on "zeromq"
  depends_on "pandoc" if build.with?("nbconvert") || build.with?("notebook")
  depends_on "pyqt" if build.with? "qtconsole"

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

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/1e/67/2562affb99e194cb4b0c0b88e661650d065fcf452d1108116a9530ed9cad/bleach-2.0.0.tar.gz"
    sha256 "b9522130003e4caedf4f00a39c120a906dcd4242329c1c8f621f5370203cbc30"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/17/ee/99e69cdcefc354e0c18ff2cc60aeeb5bfcc2e33f051bf0cc5526d790c445/html5lib-0.999999999.tar.gz"
    sha256 "ee747c0ffd3028d2722061936b5c65ee4fe13c8e4613519b4447123fc4546298"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/0c/41/67e16b243b78b49f4b1650d045b63be187c27d20a76f0f7b8e61e0fcb966/ipykernel-4.6.1.tar.gz"
    sha256 "2e1825aca4e2585b5adb7953ea16e53f53a62159ed49952a564b1e23507205db"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/21/86/58d06db0c82af66c2d47faead027c3ce775cfbf9bc9d2f13f85d95f0a162/ipython-5.4.1.tar.gz"
    sha256 "afaa92343c20cf4296728161521d84f606d8817f963beaf7198e63dfede897fb"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "ipywidgets" do
    url "https://files.pythonhosted.org/packages/0f/2d/55230d6127f74e25f0d41dec4c7742d8a461130a43a8c2489c200d7da16c/ipywidgets-7.0.0.tar.gz"
    sha256 "63e454202f72796044e99846881c33767c47fa050735dc1f927657b9cd2b7fcd"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "jupyter_client" do
    url "https://files.pythonhosted.org/packages/d4/51/09da9a18cd858b28cee596a628660a8cbf9830bdd89fe94361bfe18a0bb4/jupyter_client-5.1.0.tar.gz"
    sha256 "08756b021765c97bc5665390700a4255c2df31666ead8bff116b368d09912aba"
  end

  resource "jupyter_console" do
    url "https://files.pythonhosted.org/packages/cd/bb/fa8901715c009a00ea4c42897da8585189d4781c64f4617a8bd65ca01a3a/jupyter_console-5.2.0.tar.gz"
    sha256 "545dedd3aaaa355148093c5609f0229aeb121b4852995c2accfa64fe3e0e55cd"
  end

  resource "jupyter_core" do
    url "https://files.pythonhosted.org/packages/2f/39/5138f975100ce14d150938df48a83cd852a3fd8e24b1244f4113848e69e2/jupyter_core-4.3.0.tar.gz"
    sha256 "a96b129e1641425bf057c3d46f4f44adce747a7d60107e8ad771045c36514d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/25/a4/12a584c0c59c9fed529f8b3c47ca8217c0cf8bcc5e1089d3256410cfbdbc/mistune-0.7.4.tar.gz"
    sha256 "8517af9f5cd1857bb83f9a23da75aa516d7538c32a2c5d5c56f3789a9e4cd22f"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/bc/34/1862ab61293e59fa9df81da730b1ae51ba945c396ff5c2e81b77ecd4b025/nbconvert-5.3.0.tar.gz"
    sha256 "92827c21afa05b6ab83f451306f1d630d4577fd65109ac8817f118e9648791a0"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6e/0e/160754f7ae3e984863f585a3743b0ed1702043a81245907c8fae2d537155/nbformat-4.4.0.tar.gz"
    sha256 "f7494ef0df60766b7cabe0a3651556345a963b74dbc16bc7c18479041170d402"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/e2/71/49a6be47ffa566d925387ba4db1a353824e789cd785c12d2d6e3e2f30892/notebook-5.0.0.tar.gz"
    sha256 "1cea3bbbd03c8e5842a1403347a8cc8134486b3ce081a2e5b1952a00ea66ed54"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/4c/ea/236e2584af67bb6df960832731a6e5325fd4441de001767da328c33368ce/pandocfilters-1.4.2.tar.gz"
    sha256 "b3dd70e169bb5449e6bc6ff96aea89c5eea8c5f6ab5e207fc2f521a2cf4a0da9"
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
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
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

  resource "qtconsole" do
    url "https://files.pythonhosted.org/packages/68/48/ed0e8989b7376704ecb8faa782384de98cc108de522ad8d21f449484de9a/qtconsole-4.3.1.tar.gz"
    sha256 "eff8c2faeda567a0bef5781f419a64e9977988db101652b312b9d74ec0a5109c"
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

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/58/59/aabe84fce2f45da10165435cec204d982863e176f6849a4a4fe2652a20a8/terminado-0.6.tar.gz"
    sha256 "2c0ba1f624067dccaaead7d2247cfe029806355cef124dc2ccb53c83229f0126"
  end

  resource "testpath" do
    url "https://files.pythonhosted.org/packages/f4/8b/b71e9ee10e5f751e9d959bc750ab122ba04187f5aa52aabdc4e63b0e31a7/testpath-0.3.1.tar.gz"
    sha256 "0d5337839c788da5900df70f8e01015aec141aa3fe7936cb0d0a2953f7ac7609"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/fa/14/52e2072197dd0e63589e875ebf5984c91a027121262aa08f71a49b958359/tornado-4.5.2.tar.gz"
    sha256 "1fb8e494cd46c674d86fac5885a3ff87b0e283937a47d74eb3c02a48c9e89ad0"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"
    sha256 "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "widgetsnbextension" do
    url "https://files.pythonhosted.org/packages/5a/ed/77cbdc2e2aae4a006627044a99ed89a89827435150c44f1106f5205f9326/widgetsnbextension-3.0.2.tar.gz"
    sha256 "e8890d87c80782ee4ea3ed9afffc89a0af8b4ff475d1608d900f728ea55f041c"
  end

  def install
    ENV["JUPYTER_PATH"] = etc/"jupyter"
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # gather packages to link based on options
    linked = %w[jupyter_core jupyter_client nbformat ipykernel jupyter_console
                nbconvert notebook qtconsole]
    dependencies = resources.map(&:name).to_set - linked

    if build.with?("notebook") && build.without?("nbconvert")
      dependencies << "nbconvert"
    end

    linked.delete "jupyter_console" if build.without? "console"
    linked.delete "nbconvert" if build.without? "nbconvert"
    linked.delete "notebook" if build.without? "notebook"
    linked.delete "qtconsole" if build.without? "qtconsole"

    # install dependent packages
    dependencies.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install main packages and link with env script
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    linked.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :JUPYTER_PATH => ENV["JUPYTER_PATH"], :PYTHONPATH => ENV["PYTHONPATH"])

    # remove bundled kernel
    rm_rf Dir["#{libexec}/share/jupyter/kernels"]
  end

  def caveats; <<~EOS
    Additional kernels can be installed into the shared jupyter directory
      #{etc}/jupyter
    EOS
  end

  test do
    assert_match "python2", shell_output("#{bin}/jupyter kernelspec list")

    if build.with? "console"
      (testpath/"console.exp").write <<~EOS
        spawn #{bin}/jupyter-console
        expect "In "
        send "exit\r"
      EOS
      assert_match "Jupyter console", shell_output("expect -f console.exp")
    end

    if build.with? "notebook"
      (testpath/"notebook.exp").write <<~EOS
        spawn #{bin}/jupyter-notebook --no-browser
        expect "NotebookApp"
      EOS
      assert_match "NotebookApp", shell_output("expect -f notebook.exp")
    end

    if build.with? "nbconvert"
      (testpath/"nbconvert.ipynb").write <<~EOS
        {
          "cells": []
        }
      EOS
      system bin/"jupyter-nbconvert", "nbconvert.ipynb"
      assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"
    end

    if build.with? "qtconsole"
      (testpath/"qtconsole.exp").write <<~EOS
        spawn #{bin}/jupyter-qtconsole
      EOS
      system "expect", "-f", "qtconsole.exp"
    end
  end
end
