class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/ae/b9/3c5dcecdc658783fee3dd760a9e1957312a2d9d75b8d8fc6988f629ab14a/ipython-7.20.0.tar.gz"
  sha256 "1923af00820a8cf58e91d56b89efc59780a6e81363b94464a0f17c039dffff9e"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7d5dd05d06f52b5bd0d36a70f9e5641e8d200fa05231f3f3c7b74366e85361ba"
    sha256 cellar: :any, big_sur:       "ab164c8802997467b514f3b81fbc4fe574a434983656231c96917097c3c7ac25"
    sha256 cellar: :any, catalina:      "d16fd8efa286230cf06d673f390161c865870987c19f8a986124f586cf0aeb95"
    sha256 cellar: :any, mojave:        "03108123ed431e372403798444ad09723dffc9ea3cc5a5870ed5aa47337aa1df"
  end

  depends_on "python@3.9"
  depends_on "zeromq"

  # use resources from ipykernel (which includes ipython)
  resource "appnope" do
    url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
    sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/5e/bf/a7184ba49ff503ca6328e5331d71e08ee446255009ef7b4bfd7e3adf60a5/ipykernel-5.4.3.tar.gz"
    sha256 "697103d218e9a8828025af7986e033c89e0b36e2b6eb84a5bda4739b9a27f3cb"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/6e/12/beb24fccdb337873a550ff8355237043e159b5d56d0a903039ebfd17d6be/jupyter_client-6.1.11.tar.gz"
    sha256 "649ca3aca1e28f27d73ef15868a7c7f10d6e70f761514582accec3ca6bb13085"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/24/9a/0ca76ccc95eeb3ee376c671e81bda2c61d148c7627443004d1ba0d085b80/jupyter_core-4.7.1.tar.gz"
    sha256 "79025cb3225efcd36847d0840f3fc672c0abd7afd0de83ba8a1d3837619122b4"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5d/62/31ce4b24055558771af3498266852e1a89b4ca43ecec251b16122da32dbd/parso-0.8.1.tar.gz"
    sha256 "8519430ad07087d4c997fda3a7918f7cfa27cb58972a8c89c2a0295a1c940e9e"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/46/4eb242362c43cf033b4ec4d7205612c46c9f904a8984cdfdb64d35476175/prompt_toolkit-3.0.14.tar.gz"
    sha256 "7e966747c18ececaec785699626b771c1ba8344c8d31759a1915d6b12fad6525"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/d7/4f/2e09600112c1e69ea7eefef3db443d966ae670a5b9fa229fe6eb84e945a4/pyzmq-22.0.2.tar.gz"
    sha256 "d7b82a959e5e22d492f4f5a1e650e909a6c8c76ede178f538313ddb9d1e92963"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/b8/24/e6dfe45ecfc4c2b0d6774565e631dc1b9e50de2c3536625d377963d56cae/traitlets-5.0.5.tar.gz"
    sha256 "178f4ce988f69189f7e523337a3e11d91c786ded9360174a3d9ca83e79bc5396"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # install other resources
    ipykernel = resource("ipykernel")
    (resources - [ipykernel]).each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install and link IPython
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
    bin.install libexec/"bin/ipython"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH")

    # install IPython man page
    man1.install libexec/"share/man/man1/ipython.1"

    # install IPyKernel
    ipykernel.stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # install kernel
    kernel_dir = Dir.mktmpdir
    system libexec/"bin/ipython", "kernel", "install", "--prefix", kernel_dir
    (share/"jupyter/kernels/python3").install Dir["#{kernel_dir}/share/jupyter/kernels/python3/*"]
    inreplace share/"jupyter/kernels/python3/kernel.json", "]", <<~EOS
      ],
      "env": {
        "PYTHONPATH": "#{ENV["PYTHONPATH"]}"
      }
    EOS
  end

  def post_install
    rm_rf etc/"jupyter/kernels/python3"
    (etc/"jupyter/kernels/python3").install Dir[share/"jupyter/kernels/python3/*"]
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp

    system bin/"ipython", "kernel", "install", "--prefix", testpath
    assert_predicate testpath/"share/jupyter/kernels/python3/kernel.json", :exist?, "Failed to install kernel"
  end
end
