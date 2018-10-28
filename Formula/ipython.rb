class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/f3/c3/6c0af5b99d9551fa7b33c674d8f1232033678dcc817098e7a4ac8cd0baf1/ipython-7.1.1.tar.gz"
  sha256 "b10a7ddd03657c761fc503495bc36471c8158e3fc948573fb9fe82a7029d8efd"
  head "https://github.com/ipython/ipython.git"

  bottle do
    cellar :any
    sha256 "66d046e13fe9397e541cb87cb3082a8f583b2342f8a4601db958a1728e3737d9" => :mojave
    sha256 "240e889031eb191bd8f0bd090712fe97ff05a0394eafc223be86b29b11ebcb10" => :high_sierra
    sha256 "6888108b5d282bd765ec12ee0749eafbef406562031f526abeab3acf7990f880" => :sierra
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
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/11/0b/95330660f8cc5d63428b9886c800ea8d68842fd866389cf579acca4915be/ipykernel-5.1.0.tar.gz"
    sha256 "0fc0bf97920d454102168ec2008620066878848fcfca06c22b669696212e292f"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c1/fd/cba30adcd2a739b1288b9dc87830c28797181492757080294523d03599e6/jedi-0.13.1.tar.gz"
    sha256 "b7493f73a2febe0dc33d51c99b474547f7f6c0b2c8fb2b21f453eef204c12148"
  end

  resource "jupyter_client" do
    url "https://files.pythonhosted.org/packages/4c/df/1e8df7f4de63cc667a7a9aa234539c0419513bf94ac57d36d73b3b434786/jupyter_client-5.2.3.tar.gz"
    sha256 "27befcf0446b01e29853014d6a902dd101ad7d7f94e2252b1adca17c3466b761"
  end

  resource "jupyter_core" do
    url "https://files.pythonhosted.org/packages/b6/2d/2804f4de3a95583f65e5dcb4d7c8c7183124882323758996e867f47e72af/jupyter_core-4.4.0.tar.gz"
    sha256 "ba70754aa680300306c699790128f6fbd8c306ee5927976cbe48adacf240c0b7"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/46/31/60de7c9cbb97cac56b193a5b61a1fd4d21df84843a570b370ec34781316b/parso-0.3.1.tar.gz"
    sha256 "35704a43a3c113cce4de228ddb39aab374b8004f4f2407d070b6a2ca784ce8a2"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/89/43/07d07654ee3e25235d8cea4164cdee0ec39d1fda8e9203156ebe403ffda4/pexpect-4.6.0.tar.gz"
    sha256 "2a8e88259839571d1251d278476f3eec5db26deb73a70be5ed5dc5435e418aba"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/96/29/179b81ea51e5abbd04888489d745ef4817c0c1b29b2a3f8efe7ea569b4a4/prompt_toolkit-2.0.6.tar.gz"
    sha256 "82766ffd7397e6661465e20bd1390db0781ca4fbbab4cf6c2578cacdd8b09754"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/b9/6a/bc9277b78f5c3236e36b8c16f4d2701a7fd4fa2eb697159d3e0a3a991573/pyzmq-17.1.2.tar.gz"
    sha256 "a72b82ac1910f2cf61a49139f4974f994984475f771b0faa730839607eeedddf"
  end

  resource "simplegeneric" do
    url "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"
    sha256 "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/e6/78/6e7b5af12c12bdf38ca9bfe863fcaf53dc10430a312d0324e76c1e5ca426/tornado-5.1.1.tar.gz"
    sha256 "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409"
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
