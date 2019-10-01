class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/89/60/acb98588d8eba96558e69d90fa54f9908b4e48f6492ff378697f0c2216e2/ipython-7.8.0.tar.gz"
  sha256 "dd76831f065f17bddd7eaa5c781f5ea32de5ef217592cf019e34043b56895aa1"
  head "https://github.com/ipython/ipython.git"

  bottle do
    cellar :any
    sha256 "c0274d476c8e39bce7e6a74cef00273706bca02c806d9464bf1f9b85c7fa5982" => :catalina
    sha256 "b28a7d61d57071008e1d46ce1da422ae93274e768d92794fbdb2703a95ecf03e" => :mojave
    sha256 "5cf337c88027281e8806c4c506b7b7e94dc3b280a2372e7e7f894eec3cb60bd2" => :high_sierra
    sha256 "1711132d40e7781f60e874b52810019bcc11d9221b36770512a1fcd497f19dee" => :sierra
  end

  depends_on "python"
  depends_on "zeromq"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz"
    sha256 "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2/decorator-4.4.0.tar.gz"
    sha256 "86156361c50488b84a3f148056ea716ca587df2f0de1d34750d35c21312725de"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/54/c9/5cb348d0bde4d4f05443c23c1aaf8965d19cf106d1ec0e70195012f5cf9d/ipykernel-5.1.2.tar.gz"
    sha256 "b503913e0b4cce7ed2de965457dfb2edd633e8234161a60e23f2fe2161345d12"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/85/03/cd5a6e44a5753b4d539288d9d1f9645caac889c17dd2950292a8818f86b2/jedi-0.15.1.tar.gz"
    sha256 "ba859c74fa3c966a22f2aeebe1b74ee27e2a462f56d3f5f7ca4a59af61bfe42e"
  end

  resource "jupyter_client" do
    url "https://files.pythonhosted.org/packages/25/90/314cb3c69f25e70f82ba8528e536fbe66510daff83f22ef3f22082986a9e/jupyter_client-5.3.1.tar.gz"
    sha256 "98e8af5edff5d24e4d31e73bc21043130ae9d955a91aa93fc0bc3b1d0f7b5880"
  end

  resource "jupyter_core" do
    url "https://files.pythonhosted.org/packages/4a/de/ff4ca734656d17ebe0450807b59d728f45277e2e7f4b82bc9aae6cb82961/jupyter_core-4.5.0.tar.gz"
    sha256 "2c6e7c1e9f2ac45b5c2ceea5730bc9008d92fe59d0725eac57b04c0edfba24f7"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/21/40/615957db4d178b7504c87b1a5b85fa5945b0b4fa5f5a845e31fc7aad6018/parso-0.5.1.tar.gz"
    sha256 "666b0ee4a7a1220f65d367617f2cd3ffddff3e205f3f16a0284df30e774c2a9c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/1c/b1/362a0d4235496cb42c33d1d8732b5e2c607b0129ad5fdd76f5a583b9fcb3/pexpect-4.7.0.tar.gz"
    sha256 "9e2c1fd0e6ee3a49b28f95d4b33bc389c89b20af6a1255906e90ff1262ce62eb"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/94/a0/57dc47115621d9b3fcc589848cdbcbb6c4c130186e8fc4c4704766a7a699/prompt_toolkit-2.0.9.tar.gz"
    sha256 "2519ad1d8038fd5fc8e770362237ad0364d16a7650fb5724af6997ed5515e3c1"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/7a/d2/1eb3a994374802b352d4911f3317313a5b4ea786bc830cc5e343dad9b06d/pyzmq-18.1.0.tar.gz"
    sha256 "93f44739db69234c013a16990e43db1aa0af3cf5a4b8b377d028ff24515fbeb3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/30/78/2d2823598496127b21423baffaa186b668f73cd91887fcef78b6eade136b/tornado-6.0.3.tar.gz"
    sha256 "c845db36ba616912074c5b1ee897f8e0124df269468f25e4fe21fe72f6edd7a9"
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
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # install other resources
    ipykernel = resource("ipykernel")
    (resources - [ipykernel]).each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install and link IPython
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install libexec/"bin/ipython"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # install IPython man page
    man1.install libexec/"share/man/man1/ipython.1"

    # install IPyKernel
    ipykernel.stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
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
