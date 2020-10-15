class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/14/ef/9226d6a47f34afacb241b3d8acf25e5cd958a17f7bdb9f24d3b284aa59e0/peru-1.2.0.tar.gz"
  sha256 "5bcf70b49fd5a6b089a23d49d93fd6deb05bde560219704de53ae5e48cb49acb"
  license "MIT"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "505d7ab6f8c65dd5414a67e88b1a30ca0a1dbab35415b4c48aea8ab99616362f" => :catalina
    sha256 "31f7ea3a66e854e6dddfa1127b3d208f6a04406cb0aa6e4b94a034c63c7bd2db" => :mojave
    sha256 "c4eb15429ad2c832220b2ac782745e06bfc29dd8c6a7a3bce15b9291246793ac" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.9"

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
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.9"
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
