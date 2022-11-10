class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/91/77/2fc5418edff33060dd7a51aa323ee7d3df11503952b8e4e46ee65d18d815/gitlint-core-0.17.0.tar.gz"
  sha256 "772dfd33effaa8515ca73e901466aa938c19ced894bec6783d19691f57429691"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9fec3ba5aa0a725cd75ffaf02dd2fbbc5b4faee1caedd3b9545bfba8bfe450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b627c6f77c13581f287517a58a469acebbd14b23e689fd24cdaba348a5261e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d94ec8a12bf02918352e4d8fd9d70911600c91d238273ade01222fa53aa2dd18"
    sha256 cellar: :any_skip_relocation, monterey:       "55efc4020ad18a7016eb15accbc954d324b10cc808d3b6f37c79e2c6a379a5e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "26b7d5ec233f3f3abf73c21349a231ae1c83437c84de995fc1569303f55f86f4"
    sha256 cellar: :any_skip_relocation, catalina:       "394dbf545e6cdce0d8b37144fac453a83b7d4453f7696200caf2554cc235dcc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981c39070f2a6dbf3f8154da1fa0f1f454abb298a81cc7434363b597d52c0f73"
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
