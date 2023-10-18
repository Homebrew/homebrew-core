class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 2
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc87506d7629f86f1b07e10bd7015e113d29d1890b8dab246cb00e654a578478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4967435bbb849f8ce218e7f7fd6a3046e868257a79121869e140eee971a150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219b6eba95efe4748c6c4a2c9785258e7f78fe2164b35563789cb243499d85f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "250859f4f5e3c47c21f7d99474d96110852b4f3cb7f1c6b4d6837f2583d7c7e9"
    sha256 cellar: :any_skip_relocation, ventura:        "eed5dec8d78e5c354ff286c5b5d4a93075afc3f84dae12a304261618d3783aec"
    sha256 cellar: :any_skip_relocation, monterey:       "75a5c52ab206fbbab948e5cc85111b1ae7a8e6e84d00553205417c51fb88a266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e47f6fa0ecea6aebe61c26eb0bc4725d55daa0fd168602305f3986ff3e2571"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
    man1.install Utils::Gzip.compress("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
