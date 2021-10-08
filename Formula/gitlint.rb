class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.github.io/gitlint"
  url "https://files.pythonhosted.org/packages/9a/0c/bacbf0ea52b924ff7d6984b2756e544d0e276c56663bb37e0c08781d4ad3/gitlint-0.16.0.tar.gz"
  sha256 "30ee2bdae611bbf66df6326b5da1afc14bf0be337e1d3021fafeb7f13b37f55b"
  license "MIT"
  head "https://github.com/jorisroovers/gitlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7ec47daa6ce81ef96ffbda7bdace13825e0f6d05a63a6c38f858a3f2cadee50"
    sha256 cellar: :any_skip_relocation, big_sur:       "5029a4a0eb91128dccfdf00b6834cfdd2d9fb81626d8e2f952c44883495c5770"
    sha256 cellar: :any_skip_relocation, catalina:      "29ff0c17dce6e8b371bd86a6cd78cbceb8eee6b1c277b14150f03913fdbd4fa8"
    sha256 cellar: :any_skip_relocation, mojave:        "5d0b6d417829fec781059eaf33f7168dd6bb10ea5aad92b99e82c73015fb2316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47bed84615669a6ae1eb54e7dd050f00556b48871546ffae6e7074ace2f756d"
  end

  depends_on "python@3.10"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/dc/bd/2565b8533bb8cf66e10a9e68a1d489ad839799b2050f0635039e614e3b1a/arrow-1.2.0.tar.gz"
    sha256 "16fc29bbd9e425e3eb0fef3018297910a0f4568f21116fc31771e2760a50e074"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
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
