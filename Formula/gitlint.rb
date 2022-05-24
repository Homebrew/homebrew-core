class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/91/77/2fc5418edff33060dd7a51aa323ee7d3df11503952b8e4e46ee65d18d815/gitlint-core-0.17.0.tar.gz"
  sha256 "772dfd33effaa8515ca73e901466aa938c19ced894bec6783d19691f57429691"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9ad929082af6a7d59dc9f7916fb11bbbe1b6d73d65ec18f4daf1f4c85610125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa744d7a0efdb919426cc246447817ca12c41f4fd971099d0a30331c232c14b4"
    sha256 cellar: :any_skip_relocation, monterey:       "f06c6dcf8980745fd7cae9c0f4bc7af1748290d83d707dc8161571f6aa8c669d"
    sha256 cellar: :any_skip_relocation, big_sur:        "29177c2fcddbadf9cdba116e956f91c9ce5d3199c405f5933a2ea07bd28585c3"
    sha256 cellar: :any_skip_relocation, catalina:       "60bb922ea7278aa56b3e2b4e17c3629ed206229b6aa0f9941ff947462215be90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df1ea0e66d8a6c02557a1f08cd0d6c15077ad4ee3e6a337788857128c11ea10"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/80/39/ed280d183c322453e276a518605b2435f682342f2c3bcf63228404d36375/sh-1.14.2.tar.gz"
    sha256 "9d7bd0334d494b2a4609fe521b2107438cdb21c0e469ffeeb191489883d6fe0d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system "#{bin}/gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end
