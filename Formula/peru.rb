class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/8e/c7/c451e70443c0b82440384d51f4b9517b921d4fe44172d63dc10a09da114f/peru-1.3.1.tar.gz"
  sha256 "31cbcc3b1c0663866fcfb2065cb7ac26fda1843a3e5638f260cc0d78b3372f39"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caa408ed59905d90c3c2ff47776baa7167b296a9912af66a76132ddf38de9797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caa408ed59905d90c3c2ff47776baa7167b296a9912af66a76132ddf38de9797"
    sha256 cellar: :any_skip_relocation, monterey:       "4a3549daa80fe2c5a910e068de147d2f48075eabfd587ab4b38f6b0409e90451"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a3549daa80fe2c5a910e068de147d2f48075eabfd587ab4b38f6b0409e90451"
    sha256 cellar: :any_skip_relocation, catalina:       "4a3549daa80fe2c5a910e068de147d2f48075eabfd587ab4b38f6b0409e90451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6a4c2c805a4cb3f0d5077dce0bcf677ec9dce176ccfd6f88bbf03d4f79c085"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.10"
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
