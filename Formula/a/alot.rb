class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  # TODO: check if we can remove `standard-mailcap` from `pypi_packages`
  # https://github.com/pazz/alot/issues/1632
  url "https://github.com/pazz/alot.git",
      tag:      "0.11",
      revision: "a8a108e2344656a13bca21211ccc0df2414cbef6"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/pazz/alot.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682d580669a0e7e68d83a60bf92d879e8c9260b14cc775a066f9460336186e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2073f6c4e5efd15df25adcfb47610e6e660459b4887eb65781758e25122fcce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce121172682f2fa975d6bea984bc29140c5d15e2acb6711fb4e593e9cd64b861"
    sha256 cellar: :any_skip_relocation, sonoma:        "0182e95a1b54b00b0d23616ac1e22757ead4f31a7f6d29a71282cfe220ebc538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fe63c1ecf7ed1c13992b031363ce9fc57c9ed8b8f392a0f37f8b9260018e287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9196aa41058870ae15ec07ab9fc659d7c5317547ebc7664af48ba85f223508"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgmepy" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "notmuch"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "notmuch2",
                extra_packages:   "standard-mailcap"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/27/87/156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6/incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/07/8c/14c2ae915e5f9dca5a22edd68b35be94400719ccfa068a03e0fb63d0f6f6/mock-5.2.0.tar.gz"
    sha256 "4e460e818629b4b173f32d08bf30d3af8123afbb8e04bb5707a1fd4799e503f0"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "standard-mailcap" do
    url "https://files.pythonhosted.org/packages/53/e8/672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75/standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/13/0f/82716ed849bf7ea4984c21385597c949944f0f9b428b5710f79d0afc084d/twisted-25.5.0.tar.gz"
    sha256 "1deb272358cb6be1e3e8fc6f9c8b36f78eb0fa7c2233d2dbe11ec6fee04ea316"

    # Fix asyncio error with Python 3.14, remove in next release
    # PR ref: https://github.com/twisted/twisted/pull/12508
    patch do
      url "https://github.com/twisted/twisted/commit/c8a4c700a71c283bd65faee69820f88ec97966cb.patch?full_index=1"
      sha256 "04b849f18e6ef01e7ee2903dba13ffa8bcb04c6d9c182d25410605320d819bd2"
    end
    patch do
      url "https://github.com/twisted/twisted/commit/69b81f9038eea5ef60c30a3460abb4cc26986f72.patch?full_index=1"
      sha256 "f999fc976327e955fbe82348dfd8c336925bc1f87cfaf4bd4c95deeb0570116d"
    end
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/bb/d3/09683323e2290732a39dc92ca5031d5e5ddda56f8d236f885a400535b29a/urwid-3.0.3.tar.gz"
    sha256 "300804dd568cda5aa1c5b204227bd0cfe7a62cef2d00987c5eb2e4e64294ed9b"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/43/e1/ca5cf122cf1121b55acb39a1fb7e9fb1283c2eb0dc75fca751eb8c16b2f9/urwidtrees-1.0.3.tar.gz"
    sha256 "50b19c06b03a5a73e561757a26d449cfe0c08afabe5c0f3cd4435596bdddaae9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/88/3a/7fcf02178b8fad0a51e67e32765cd039ae505d054d744d76b8c2bbcba5ba/zope_interface-8.0.1.tar.gz"
    sha256 "eba5610d042c3704a48222f7f7c6ab5b243ed26f917e2bc69379456b115e02d1"
  end

  def install
    venv = virtualenv_install_with_resources

    pkgshare.install Pathname("extra").children - [Pathname("extra/completion")]
    zsh_completion.install "extra/completion/alot-completion.zsh" => "_alot"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["SPHINXBUILD"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    cd "docs" do
      system "make", "pickle"
      system "make", "man", "html"
      man1.install "build/man/alot.1"
      doc.install Pathname("build/html").children
    end
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    system Formula["notmuch"].bin/"notmuch", "new"

    require "pty"
    PTY.spawn(bin/"alot", "--logfile", testpath/"out.log") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end

    assert_path_exists testpath/"out.log", "out.log file should exist"
    assert_match "setup gui", (testpath/"out.log").read
  end
end
