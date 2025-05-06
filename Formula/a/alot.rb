class Alot < Formula
  include Language::Python::Virtualenv

  desc "Text mode MUA using notmuch mail"
  homepage "https://github.com/pazz/alot"
  # TODO: check if we can remove `standard-mailcap` from pypi_formula_mappings.json
  # https://github.com/pazz/alot/issues/1632
  url "https://github.com/pazz/alot.git",
      tag:      "0.11",
      revision: "a8a108e2344656a13bca21211ccc0df2414cbef6"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/pazz/alot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0b23d34625ee35bdf19c6f5092d08aacd2e664df666c6fe4ddde34cde674a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba913b1ac4fc69ef4228a90031f24237a6a831b0fa3a749c2f30b0216be481c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae3093b552e4356af46b534412c2aaeac27921b04d7b79ba80d58d712dca1be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b227c60e1cc403080fa8c14f5b97ab1634fd0e54f31f696fd61fbfa9b8ee84b7"
    sha256 cellar: :any_skip_relocation, ventura:       "435c5020ea65a79b2d3f016cd82d2c63c65302dad9f3a946e2f1b82cde02852c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbedea413b1240a740111e09751bd30f3accfa52951214658ba71fcfb105e849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e1d080cafcf5344a658d854bafd8f0b44483568a9f39301b23f5179048ab8d"
  end

  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libmagic"
  depends_on "notmuch"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/8d/2d/ede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82/automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
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
    url "https://files.pythonhosted.org/packages/4c/f4/aa8d364f0dc1f33b2718938648c31202e2db5cd6479a73f0a9ca5a88372d/setuptools-78.0.2.tar.gz"
    sha256 "137525e6afb9022f019d6e884a319017f9bf879a0d8783985d32cbc8683cab93"
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
    url "https://files.pythonhosted.org/packages/77/1c/e07af0df31229250ab58a943077e4adbd5e227d9f2ac826920416b3e5fa2/twisted-24.11.0.tar.gz"
    sha256 "695d0556d5ec579dcc464d2856b634880ed1319f45b10d19043f2b57eb0115b5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/98/21/ad23c9e961b2d36d57c63686a6f86768dd945d406323fb58c84f09478530/urwid-2.6.16.tar.gz"
    sha256 "93ad239939e44c385e64aa00027878b9e5c486d59e855ec8ab5b1e1adcdb32a2"
  end

  resource "urwidtrees" do
    url "https://files.pythonhosted.org/packages/43/e1/ca5cf122cf1121b55acb39a1fb7e9fb1283c2eb0dc75fca751eb8c16b2f9/urwidtrees-1.0.3.tar.gz"
    sha256 "50b19c06b03a5a73e561757a26d449cfe0c08afabe5c0f3cd4435596bdddaae9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/30/93/9210e7606be57a2dfc6277ac97dcc864fd8d39f142ca194fdc186d596fda/zope.interface-7.2.tar.gz"
    sha256 "8b49f1a3d1ee4cdaf5b32d2e738362c7f5e40ac8b46dd7d1a65e82a4872728fe"
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
