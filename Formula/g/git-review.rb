class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/79/ae/1c161f8914731ca5a5b3ce0784f5bc47d9a68f4ce33123d431bf30fc90b6/git-review-2.4.0.tar.gz"
  sha256 "a350eaa9c269a1fe3177a5ffd4ae76f2b604e1af122eb0de08ab07252001722a"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd033c85b9136adc4be56c4a98b66258fa1bd501acfded578b1b1625ffe034c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6d78542f921543633492fb6a011185607fc7e802f6be34c781e96c20a9d1a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfb8bca2b703150ef55217eb03ff4dc1662b7ff65fb9364e6810919e2b03b86"
    sha256 cellar: :any_skip_relocation, sonoma:         "17dc8b6d57e33c52ce78c2cd99a4c515102ca89d082e99473e979c3fc27d054e"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3ebee625d98533abe087b7f80a5fa22c4fa78c3378a816732218d380b6b93e"
    sha256 cellar: :any_skip_relocation, monterey:       "3637833a6c6fd6fc0449718db192426f98cbe972624d76adec9a78512702e5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e5db0d2e62795718a77d3a3373214333fdecd56fa29b92f434eed5a1b0e9d2"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
