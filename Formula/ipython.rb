class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/24/65/7f9da61ec569eb4e96081ef802755295a213141908be2958c6771db4b04c/ipython-8.2.0.tar.gz"
  sha256 "70e5eb132cac594a34b5f799bd252589009905f05104728aea6a403ec2519dc1"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3a3055fe18a6076fffa12faf17f2da4d929e42b1b9cfda12b92703448879675"
    sha256 cellar: :any,                 arm64_big_sur:  "d9dc0b491830a60256e159782d63a53e4d007e8d5d9becdd400eac89d8e219b7"
    sha256 cellar: :any,                 monterey:       "5d08a54dc83fd661474ceae79361e984db25eac44d61aedcd5cac89f844fe564"
    sha256 cellar: :any,                 big_sur:        "4d1ab1f5e26fca484a3f3104342e33ae3b5b9a4dfd02c7ffbf324a4ba74ef066"
    sha256 cellar: :any,                 catalina:       "54bf070c554cdcd742b8b0fccec6902ecdeb2698a65b3ccdb4ed3f4fe67822a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8125050f03d0ffb8bcd76b0155cfa22c1bd1fc1c14912b03420119a3091fb685"
  end

  depends_on "python@3.10"
  depends_on "six"
  depends_on "zeromq"

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

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/68/8a/aba73af65eb84e0c61c658d2aa2f2a9b4d2939a7f87294dd396f4987efac/debugpy-1.5.1.zip"
    sha256 "d2b09e91fbd1efa4f4fda121d49af89501beda50c18ed7499712c71a4bf3452e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/16/14/5a9b7b7725e85aa66f00a89f1e912ded203217016562747f8b8effcf52bc/executing-0.8.3.tar.gz"
    sha256 "c6554e21c6b060590a6d3be4b82fb78f8f0194d809de5ea7df1c093763311501"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/e7/b2/0db7e5e7c2de514de42f9a95a09b421d18b7cd6f4a69af19f4cf46c48d13/ipykernel-6.9.2.tar.gz"
    sha256 "4c3cc8cb359f2ead70c30f5504971c0d285e2c1c699d2ce9af0216fe9c9fb17c"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/2d/8b/4c9c3623608b31370f5dd02963801adc36a81ba95b8e1a1a4deacdd84973/jupyter_client-7.1.2.tar.gz"
    sha256 "4ea61033726c8e579edb55626d8ee2e6bf0a83158ddf3751b8dd46b2c5cd1e96"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/36/2a/c37700729318ffa5e54de7f94b69d38bd2dca58a52cafe9eada3d7fc9fd5/jupyter_core-4.9.2.tar.gz"
    sha256 "d69baeb9ffb128b8cd2657fcf2703f89c769d1673c851812119e3a2a0e93ad9a"
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
    url "https://files.pythonhosted.org/packages/37/34/c34c376882305c5051ed7f086daf07e68563d284015839bfb74d6e61d402/prompt_toolkit-3.0.28.tar.gz"
    sha256 "9f1cd16b1e86c2968f2519d7fb31dd9d669916f515612c269d14e9ed52b51650"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/97/5a/0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fd/pure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
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
    url "https://files.pythonhosted.org/packages/3c/71/3e7cdd62d35c863dc45248d827cb65858af6b58271da5ff930bc60ba2e87/stack_data-0.2.0.tar.gz"
    sha256 "45692d41bd633a9503a5195552df22b583caf16f0b27c4e58c98d88c8b648e12"
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
