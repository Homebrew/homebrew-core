class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.github.io/gitlint"
  url "https://files.pythonhosted.org/packages/91/77/2fc5418edff33060dd7a51aa323ee7d3df11503952b8e4e46ee65d18d815/gitlint-core-0.17.0.tar.gz"
  sha256 "772dfd33effaa8515ca73e901466aa938c19ced894bec6783d19691f57429691"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6931b626fbece9c095c2e5e0c209652372615253a6d35de78daf237e82bf68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bcbf70697da339aa2a7c794377187c57c7618d32ef7c538b36d37480b5f6c42"
    sha256 cellar: :any_skip_relocation, monterey:       "32225c3fa4b996482313fa7d51e7e40505d06b0fa0f8cd7e160b3fa418d84a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "95e74a0cfd189c140ea05874f9a82e605992666cbff78b48f661189e83aec2f2"
    sha256 cellar: :any_skip_relocation, catalina:       "a2305c81e08d6910cc1332f5ffdb40866ae9b166c0687025a9400739461567ed"
    sha256 cellar: :any_skip_relocation, mojave:         "8a27c21879cfcd036c2acd9a1160b9467fdeff0121f3521150d962a29e1cc2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f26e3ff395a558ebf95cd93f9f1001a18c4d06154b2809092f9280a9f8342345"
  end

  depends_on "python@3.10"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/25/e2/85d4a709a3ea58f8e36b4db9eb7927560a2fa4b6f8f362fb6475962fec51/arrow-1.2.1.tar.gz"
    sha256 "c2dde3c382d9f7e6922ce636bf0b318a7a853df40ecb383b29192e6c5cc82840"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/80/39/ed280d183c322453e276a518605b2435f682342f2c3bcf63228404d36375/sh-1.14.2.tar.gz"
    sha256 "9d7bd0334d494b2a4609fe521b2107438cdb21c0e469ffeeb191489883d6fe0d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
