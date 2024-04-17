class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/79/ae/1c161f8914731ca5a5b3ce0784f5bc47d9a68f4ce33123d431bf30fc90b6/git-review-2.4.0.tar.gz"
  sha256 "a350eaa9c269a1fe3177a5ffd4ae76f2b604e1af122eb0de08ab07252001722a"
  license "Apache-2.0"
  revision 1
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, monterey:       "2ad6eb006c5c32abb9eb6ba8da2df4a04d46af23cb38879624ca6aa1368fa1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b010195b900eea4ea20d55cb30281dff703cb147cd4cd7659dcaa7c5f120ad97"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
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
    system bin/"git-review", "--dry-run"
  end
end
