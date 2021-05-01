class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/11/fb/5f928779d706606c95558e7838988878f0dac9508c06b3452a8708922da5/ipython-7.23.0.tar.gz"
  sha256 "69178f32bf9c6257430b6f592c3ae230c32861a1966d2facec454e09078e232d"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "84b8dc8e8f724f9204edb5654a4454090dacfc32e48fca43d34bb1698170c2ae"
    sha256 cellar: :any, big_sur:       "22068bcaefefcc7a53e24a44a5c9e1993c940b57243824d9c7966b8f1b8f8b2f"
    sha256 cellar: :any, catalina:      "13f902b04df85a4103e997119da3c10df3d803687416888f158f8a42ec640f3b"
    sha256 cellar: :any, mojave:        "4120bccd6cba7319fd1b016771546e4932d6c3d02b55c47ced72f9d6979e4b9a"
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
    url "https://files.pythonhosted.org/packages/a9/09/dd085a8afcf48fdaba851fe10956d5dbf1e9091206f7ca717223563f75c2/decorator-5.0.7.tar.gz"
    sha256 "6f201a6c4dac3d187352661f508b9364ec8091217442c9478f1f83c003a0f060"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/03/ea/bd6b7df2557fbc40640b30102bc792b754964dafcd30d3acbd82b64c4cf5/ipykernel-5.5.3.tar.gz"
    sha256 "a682e4f7affd86d9ce9b699d21bcab6d5ec9fbb2bfcb194f2706973b252bc509"
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
    url "https://files.pythonhosted.org/packages/11/ef/d93cd8446f240fe9f332963eaf0766ea366d5536f8d7b50cd54bc4f39402/jupyter_client-6.2.0.tar.gz"
    sha256 "e2ab61d79fbf8b56734a4c2499f19830fbd7f6fefb3e87868ef0545cb3c17eb9"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/24/9a/0ca76ccc95eeb3ee376c671e81bda2c61d148c7627443004d1ba0d085b80/jupyter_core-4.7.1.tar.gz"
    sha256 "79025cb3225efcd36847d0840f3fc672c0abd7afd0de83ba8a1d3837619122b4"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/c1/fb/3361c4bf5ae8ffb9249132e70f4853ef511c0894a938fdff29320df55534/matplotlib-inline-0.1.2.tar.gz"
    sha256 "f41d5ff73c9f5385775d5c0bc13b424535c8402fe70ea8210f93e11f3683993e"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/ad/82/2fdf6a92eed4ddf5e9d9a735d019af1ef3a56f084d9549972b2527a43a48/nest_asyncio-1.5.1.tar.gz"
    sha256 "afc5a1c515210a23c461932765691ad39e8eba6551c055ac8d5546e69250d0aa"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
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
    url "https://files.pythonhosted.org/packages/f7/e0/47738dadee0ec15ffbfa926f01586db2397201e0af3e06a0e669adfd6f2f/prompt_toolkit-3.0.18.tar.gz"
    sha256 "e1b4f11b9336a28fa11810bc623c357420f69dfdb6d2dac41ca2c21a55c033bc"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/a3/7a/561526861908d366ddc2764933a6090078654b0f2ff20c3c180dd5851554/pyzmq-22.0.3.tar.gz"
    sha256 "f7f63ce127980d40f3e6a5fdb87abf17ce1a7c2bd8bf2c7560e1bbce8ab1f92d"
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
