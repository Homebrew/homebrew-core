class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/14/ef/9226d6a47f34afacb241b3d8acf25e5cd958a17f7bdb9f24d3b284aa59e0/peru-1.2.0.tar.gz"
  sha256 "5bcf70b49fd5a6b089a23d49d93fd6deb05bde560219704de53ae5e48cb49acb"

  bottle do
    cellar :any_skip_relocation
    sha256 "021031ea720c6e741fc11ce1c647dda83d85eb6c5f6cb6841c0f1317e800dfeb" => :catalina
    sha256 "eb1e744ad4162d35a84ea7e2eb53450bcad6acf803dc874093b96e3c81f85c3f" => :mojave
    sha256 "785a37bcc0a2d972b62946d989226eb35d72896439c27c4ce8c34fa3c65b6e91" => :high_sierra
    sha256 "2344e0f5c3f03c8aab73eec642082f4a5913cbda9370483689b1cc154648666d" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"peru.yaml").write <<~EOS
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    EOS
    system "#{bin}/peru", "sync"
    assert_predicate testpath/".peru", :exist?
    assert_predicate testpath/"peru", :exist?
  end
end
