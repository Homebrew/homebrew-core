class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/14/ef/9226d6a47f34afacb241b3d8acf25e5cd958a17f7bdb9f24d3b284aa59e0/peru-1.2.0.tar.gz"
  sha256 "5bcf70b49fd5a6b089a23d49d93fd6deb05bde560219704de53ae5e48cb49acb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "021031ea720c6e741fc11ce1c647dda83d85eb6c5f6cb6841c0f1317e800dfeb" => :catalina
    sha256 "eb1e744ad4162d35a84ea7e2eb53450bcad6acf803dc874093b96e3c81f85c3f" => :mojave
    sha256 "785a37bcc0a2d972b62946d989226eb35d72896439c27c4ce8c34fa3c65b6e91" => :high_sierra
    sha256 "2344e0f5c3f03c8aab73eec642082f4a5913cbda9370483689b1cc154648666d" => :sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.8"
    end

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
