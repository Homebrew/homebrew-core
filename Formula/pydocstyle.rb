class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/4c/30/4cdea3c8342ad343d41603afc1372167c224a04dc5dc0bf4193ccb39b370/pydocstyle-6.1.1.tar.gz"
  sha256 "1d41b7c459ba0ee6c345f2eb9ae827cab14a7533a88c5c6f7e94923f72df92dc"
  license "MIT"
  revision 1
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6bdedcab8085ebba46a6c61be194777ed70a2ad0a59b28f482292a499430bf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f484ef39a1a165ec192fafe7f6d76c1ebf5fa97d7499d729cf1de98c6444edef"
    sha256 cellar: :any_skip_relocation, monterey:       "ac2eec2c0826c7923fbfe279c1cc587eff79ce1dd2b4c8e32daafa0f155ae01c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a454e42222a31a0437d0d33197b068b952c5a48011fe107f0d0f14f707e36f1"
    sha256 cellar: :any_skip_relocation, catalina:       "a4091b17676b23f645aec6684939a19a2a5c05f991b25e9d4ebbf09c90764084"
    sha256 cellar: :any_skip_relocation, mojave:         "84a68e5f7328a5a2127b50254e52f13a3f68f8bc718dd8ef84ceae59461a3bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a656c93ee9ed3bc8572cc415b93081e8ce24870a14ab6569b5ea08ffeb17fbf0"
  end

  depends_on "python@3.11"

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring():
        """  extra spaces  """
        pass
    EOS
    output = pipe_output("#{bin}/pydocstyle broken.py 2>&1")
    assert_match "No whitespaces allowed surrounding docstring text", output
  end
end
