class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/fe/11/971074a89e50f31e32b79b73a84b8aed5787ad5718bb3857477514304db7/gitlint-core-0.18.0.tar.gz"
  sha256 "b032eb574f7399aec6a5246a78810bacb7ce9c9fd2d9e4375950549196cae681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76c35c0f5c1264f660de5f79a30e5609247685ca0d27a0929696009870c6218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ab8cb2671afa9e4aaa8de6fda45198162567a7e8611086bce572908f4e702a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526b454400bcc7440c23e3659728140d2b96372734d4c59784e59a7ff542c98b"
    sha256 cellar: :any_skip_relocation, ventura:        "f92add1cb7cca06297104b86f6c734bc164b197b440d53d86ec880159f89c5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "2043b77407919887505d5ac40225596e536a709e290be4840e9da25587b82731"
    sha256 cellar: :any_skip_relocation, big_sur:        "a519f46cce1b93e2045ef2880012e7a811accbe1816671ebc1b102ade4142d4c"
    sha256 cellar: :any_skip_relocation, catalina:       "515ae6455446a91ae666d6e078e1c30eeaccac57f90976c6f72b867df31762e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395a1c0dc259937b455d9792749abae1235b65d1a48e10039cd2743c475b4920"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
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
    url "https://files.pythonhosted.org/packages/b7/09/89c28aaf2a49f226fef8587c90c6386bd2cc03a0295bc4ff7fc6ee43c01d/sh-1.14.3.tar.gz"
    sha256 "e4045b6c732d9ce75d571c79f5ac2234edd9ae4f5fa9d59b09705082bdca18c7"
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
