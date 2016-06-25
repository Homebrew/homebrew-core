class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/JukkaL/mypy.git",
    :tag => "v0.4.2",
    :revision => "b8a2df91707bc3d5c9c3677c8017b614e41d017a"
  head "https://github.com/JukkaL/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d472855d881f585b9236d93d67a09795543950eccb954979c4c98be8008a4a6" => :el_capitan
    sha256 "0ff20999cbd6c391dcce22c949c16701a4dd58aca17cc57e212d6a35e819f751" => :yosemite
    sha256 "bed90ec74eb884802e768059c10d435a5d7f7be2b6b990a1df6bc92291aed4d3" => :mavericks
  end

  option "without-docs", "Don't build documentation"

  depends_on :python3

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/99/b5/249a803a428b4fd438dd4580a37f79c0d552025fb65619d25f960369d76b/sphinx_rtd_theme-0.1.9.tar.gz"
    sha256 "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1"
  end

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/46/01/3539c406b47b0e44464a2b6c7b51871300d815b9d7b07c98309c9270bd50/alabaster-0.7.8.tar.gz"
    sha256 "a1cb1b94fcc192ff74ca212d6ef5cb543bb169cfe7991c2b9df256bb354c1fff"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/53/72/6c6f1e787d9cab2cc733cf042f125abec07209a58308831c9f292504e826/imagesize-0.7.1.tar.gz"
    sha256 "0ab2c62b87987e3252f89d30b7cedbec12a01af9274af9ffa48108f2c13c6062"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/20/6b/d2a7cb176d4d664d94a6debf52cd8dbae1f7203c8e42426daa077051d59c/snowballstemmer-1.2.1.tar.gz"
    sha256 "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128"
  end

  resource "Sphinx" do
    url "https://files.pythonhosted.org/packages/20/a2/72f44c84f6c4115e3fef58d36d657ec311d80196eab9fd5ec7bcde76143b/Sphinx-1.4.4.tar.gz"
    sha256 "3effd6373734bd59f7457fed2f0bd4ba7ec3c70b4598d7c2e5193a42209dbfa0"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"sphinx/lib/python#{xy}/site-packages"
      resources_no_sphinx_rtd_theme = resources - ["sphinx_rtd_theme"]
      resources_no_sphinx_rtd_theme.each do |r|
        r.stage do
          system "python3", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end

      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
      resource("sphinx_rtd_theme").stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end

      ENV.prepend_path "PATH", buildpath/"sphinx/bin"
      cd "docs" do
        system "make", "html"
        doc.install Dir["build/html/*"]
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    (testpath/"broken.py").write <<-EOS.undent
      def p() -> None:
        print ('hello')
      a = p()
    EOS

    output = pipe_output("#{bin}/mypy #{testpath}/broken.py 2>&1")
    assert_match "\"p\" does not return a value", output
    system "python3", "-c", "import typing"
  end
end
