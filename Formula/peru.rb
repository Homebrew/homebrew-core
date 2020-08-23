class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/14/ef/9226d6a47f34afacb241b3d8acf25e5cd958a17f7bdb9f24d3b284aa59e0/peru-1.2.0.tar.gz"
  sha256 "5bcf70b49fd5a6b089a23d49d93fd6deb05bde560219704de53ae5e48cb49acb"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "0cdd82ec6457445261cafdf0a64f626f1c5f64a49313bcc6f9b2694e644d4ab3" => :catalina
    sha256 "9095dd68d7702875b8138efb6b1ba49a84e9c0ba60a7d8be56019acc5422c466" => :mojave
    sha256 "0e543115564fbebe21054c2b05913efb76b03ecceb41b12d8b2081b575459e39" => :high_sierra
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
