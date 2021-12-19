class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/19/8f/8dfb6d79f39a225d2f65422392f725e904b14c4d33b5531c9a3a258c359f/ipython-7.30.1.tar.gz"
  sha256 "cb6aef731bf708a7727ab6cde8df87f0281b1427d41e65d62d4b68934fa54e97"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e6363458e5543a8dda910566e77296987bbfdb2878cbaf33ef8ab6020cb33b3"
    sha256 cellar: :any,                 arm64_big_sur:  "9096b5061aa211d059017038f9dd223845cbc0695caccded0ca10ad7b468b11b"
    sha256 cellar: :any,                 monterey:       "34624efddebb47a064eeffd6de44e7f1be13c205b93dcc6bd26aa064d536d7fd"
    sha256 cellar: :any,                 big_sur:        "a6e5a32def2178fa48f9126965e6d4630a59d1b932ab00e3e68170e1d91fb9b0"
    sha256 cellar: :any,                 catalina:       "ad323306514d664326a25fa6e872500cd3f19ef73ac38468c47372e983e6b30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238a03f68a0839f412de9b5bc4d6e0c698c3160212f59e6a436edbbeea616037"
  end

  depends_on "python@3.10"
  depends_on "six"
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

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/68/8a/aba73af65eb84e0c61c658d2aa2f2a9b4d2939a7f87294dd396f4987efac/debugpy-1.5.1.zip"
    sha256 "d2b09e91fbd1efa4f4fda121d49af89501beda50c18ed7499712c71a4bf3452e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/60/30/cf3867ce0dee0a7230ec5eb85232136c3875688816ad355a7b65f4f4e8ef/ipykernel-6.6.0.tar.gz"
    sha256 "3a227788216b43982d9ac28195949467627b0d16e6b8af9741d95dcaa8c41a89"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/47/e3/192086e7b150f1fd549115190c3525a115e86b9227d6853f7ddcb07d7dc1/jupyter_client-7.1.0.tar.gz"
    sha256 "a5f995a73cffb314ed262713ae6dfce53c6b8216cea9f332071b8ff44a6e1654"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/78/fa/a949d1f0d2aaaef1890c2ab7fee9e58ed7cc6301ebc26c0afbffff4ea6e3/jupyter_core-4.9.1.tar.gz"
    sha256 "dce8a7499da5a53ae3afd5a9f4b02e5df1d57250cf48f3ad79da23b4778cd6fa"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/0f/98/838f4c57f7b2679eec038ad0abefd1acaeec35e635d4d7af215acd7d1bd2/matplotlib-inline-0.1.3.tar.gz"
    sha256 "a04bfba22e0d1395479f866853ec1ee28eea1485c1d69a6faf00dc3e24ff34ee"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/60/51/b74def9b027b864d1d9b22dfffec4ddd83f9c15f757a5a4a412566f27670/nest_asyncio-1.5.4.tar.gz"
    sha256 "f969f6013a16fadb4adcf09d11a68a4f617c6049d7af7ac2c676110169a63abd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
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
    url "https://files.pythonhosted.org/packages/c0/50/3050bb288d0c981f073b4e83ae67e92fd286a55e81b29c9df288a2afb12f/prompt_toolkit-3.0.23.tar.gz"
    sha256 "7053aba00895473cb357819358ef33f11aa97e4ac83d38efb123e5649ceeecaf"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/6c/95/d37e7db364d7f569e71068882b1848800f221c58026670e93a4c6d50efe7/pyzmq-22.3.0.tar.gz"
    sha256 "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/db/cf/e6cbf07ce2d21a17c8379f3f2f12db413a38da5ee20809638226b1490e48/traitlets-5.1.1.tar.gz"
    sha256 "059f456c5a7c1c82b98c2e8c799f39c9b8128f6d0d46941ee118daace9eb70c7"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # install other resources
    ipykernel = resource("ipykernel")
    res = resources - [ipykernel]
    res -= [resource("appnope")] if OS.linux?
    res.each do |r|
      r.stage do
        system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install and link IPython
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
    bin.install libexec/"bin/ipython"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH")

    # install IPython man page
    man1.install libexec/"share/man/man1/ipython.1"

    # install IPyKernel
    ipykernel.stage do
      system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
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

    pydevd_vendor_dir = libexec/"vendor"/Language::Python.site_packages("python3")/"debugpy/_vendored/pydevd"
    pydevd_vendor_dir.rmtree # remove pre-built binaries
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
