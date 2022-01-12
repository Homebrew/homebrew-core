class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/c2/4f/67e0c9ab885a5ba54b6dfe5f630df70b73a2de5ef04c402e0691c1936273/ipython-8.0.1.tar.gz"
  sha256 "ab564d4521ea8ceaac26c3a2c6e5ddbca15c8848fd5a5cc325f960da88d42974"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12097d4902f0460e7d7cdb1d00efad3502d5e0e0bc9756678873151adec4d1da"
    sha256 cellar: :any,                 arm64_big_sur:  "ca6fec0cb8db938927b5e36195ab1b05edd78f3ce07b64dc715a5e5de9df6da1"
    sha256 cellar: :any,                 monterey:       "7cd467ea0a1e5b2498718d89f22b47656d91da4791bc305eea3e7b49b62e6534"
    sha256 cellar: :any,                 big_sur:        "69f7e051ff30a29a24e400ecd83df48db5ca9eb40f75e33f86ee9ce26fc28215"
    sha256 cellar: :any,                 catalina:       "a962c651116b5c1fb8860c3b0b8533992d9597b7a91baf0533af9fca18ef878f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76303384be9eec382931324852ae6cec53324001aa0dd75cdd08be401b0119da"
  end

  depends_on "python@3.10"
  depends_on "six"
  depends_on "zeromq"

  # use resources from ipykernel (which includes ipython)
  resource "appnope" do
    url "https://files.pythonhosted.org/packages/e9/bc/2d2c567fe5ac1924f35df879dbf529dd7e7cabd94745dc9d89024a934e76/appnope-0.1.2.tar.gz"
    sha256 "dd83cd4b5b460958838f6eb3000c660b1f9caf2a5b1de4264e941512f603258a"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/aa/51/59965dead3960a97358f289c7c11ebc1f6c5d28710fab5d421000fe60353/asttokens-2.0.5.tar.gz"
    sha256 "9a54c114f02c7a9480d56550932546a3f1fe71d8a02f1bc7ccd0ee3ee35cf4d5"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/f7/60/7a9775dc1b81a572eb26836c7e77c92bf454ada00693af4b2d2f2614971a/black-21.12b0.tar.gz"
    sha256 "77b80f693a569e2e527958459634f18df9b0ba2625ba4e0c2d5da5be42e6f2b3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/68/8a/aba73af65eb84e0c61c658d2aa2f2a9b4d2939a7f87294dd396f4987efac/debugpy-1.5.1.zip"
    sha256 "d2b09e91fbd1efa4f4fda121d49af89501beda50c18ed7499712c71a4bf3452e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/ca/e4/efb182548f9931b36b76fd9ba2236bfc5e6d342c905beff92e868afb5b5c/executing-0.8.2.tar.gz"
    sha256 "c23bf42e9a7b9b212f185b1b2c3c91feb895963378887bb10e64a2e612ec0023"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/f5/e9/fb451fa1c2439c8ad3670cc341b7837f2a8a7749de45720bf735f9c74666/ipykernel-6.7.0.tar.gz"
    sha256 "d82b904fdc2fd8c7b1fbe0fa481c68a11b4cd4c8ef07e6517da1f10cc3114d24"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/6d/e4/669b78fa5905325f5ef4def0ee17a70729246b24f28de832926bb9bfcbb1/jupyter_client-7.1.1.tar.gz"
    sha256 "540ca35e57e83c5ece81abd9b781a57cba39a37c60a2a30c8c1b2f6663544343"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/78/fa/a949d1f0d2aaaef1890c2ab7fee9e58ed7cc6301ebc26c0afbffff4ea6e3/jupyter_core-4.9.1.tar.gz"
    sha256 "dce8a7499da5a53ae3afd5a9f4b02e5df1d57250cf48f3ad79da23b4778cd6fa"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/0f/98/838f4c57f7b2679eec038ad0abefd1acaeec35e635d4d7af215acd7d1bd2/matplotlib-inline-0.1.3.tar.gz"
    sha256 "a04bfba22e0d1395479f866853ec1ee28eea1485c1d69a6faf00dc3e24ff34ee"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/60/51/b74def9b027b864d1d9b22dfffec4ddd83f9c15f757a5a4a412566f27670/nest_asyncio-1.5.4.tar.gz"
    sha256 "f969f6013a16fadb4adcf09d11a68a4f617c6049d7af7ac2c676110169a63abd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/15/e4/f138d6319c02a6052a590ef32e94366b74581973b43665c2960b07b9ec24/prompt_toolkit-3.0.24.tar.gz"
    sha256 "1bb05628c7d87b645974a1bad3f17612be0c29fa39af9f7688030163f680bad6"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/0d/44/5cedbf05cce044385eec8f88777325259610963abbeb3c1e80f93741d17a/pure_eval-0.2.1.tar.gz"
    sha256 "0f04483b16c9429532d2c0ddc96e2b3bb6b2dc37a2bfb0e986248dbfd0b78873"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/6c/95/d37e7db364d7f569e71068882b1848800f221c58026670e93a4c6d50efe7/pyzmq-22.3.0.tar.gz"
    sha256 "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/61/11/a8cb5cad5329f2ba10a8efd5cd94d06de70caed235787665ce582381aa30/stack_data-0.1.4.tar.gz"
    sha256 "7769ed2482ce0030e00175dd1bf4ef1e873603b6ab61cd3da443b410e64e9477"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/fb/2e/d0a8276b0cf9b9e34fd0660c330acc59656f53bb2209adc75af863a3582d/tomli-1.2.3.tar.gz"
    sha256 "05b6166bff487dc068d322585c7ea4ef78deed501cc124060e0f238e89a9231f"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/db/cf/e6cbf07ce2d21a17c8379f3f2f12db413a38da5ee20809638226b1490e48/traitlets-5.1.1.tar.gz"
    sha256 "059f456c5a7c1c82b98c2e8c799f39c9b8128f6d0d46941ee118daace9eb70c7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    res = resources.reject { |r| r.name == "appnope" && OS.linux? }
    venv.pip_install res
    venv.pip_install_and_link buildpath

    # Install man page
    man1.install libexec/"share/man/man1/ipython.1"

    # Enable the kernel to be shared across envs (see also `post_install`)
    # https://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")
    Dir.mktmpdir do |tmpdir|
      system libexec/"bin/ipython", "kernel", "install", "--prefix", tmpdir
      (share/"jupyter/kernels/python3").install Dir["#{tmpdir}/share/jupyter/kernels/python3/*"]
    end
    inreplace share/"jupyter/kernels/python3/kernel.json", "]", <<~EOS
      ],
      "env": {
        "PYTHONPATH": "#{ENV["PYTHONPATH"]}"
      }
    EOS
  end

  def post_install
    rm_rf etc/"jupyter/kernels/python3"
    (etc/"jupyter/kernels").install_symlink share/"jupyter/kernels/python3"
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp

    system bin/"ipython", "kernel", "install", "--prefix", testpath
    assert_predicate testpath/"share/jupyter/kernels/python3/kernel.json", :exist?, "Failed to install kernel"
  end
end
