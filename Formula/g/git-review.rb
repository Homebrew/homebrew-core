class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/79/ae/1c161f8914731ca5a5b3ce0784f5bc47d9a68f4ce33123d431bf30fc90b6/git-review-2.4.0.tar.gz"
  sha256 "a350eaa9c269a1fe3177a5ffd4ae76f2b604e1af122eb0de08ab07252001722a"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d319cfba612259e187ba7d3fc76b46f945212cf6472fdedfe5afe7610e28b7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d319cfba612259e187ba7d3fc76b46f945212cf6472fdedfe5afe7610e28b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d319cfba612259e187ba7d3fc76b46f945212cf6472fdedfe5afe7610e28b7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "00a568c3b6096dab8773b8f7538a19b075bb644fa87de2359e146737f62df689"
    sha256 cellar: :any_skip_relocation, ventura:        "00a568c3b6096dab8773b8f7538a19b075bb644fa87de2359e146737f62df689"
    sha256 cellar: :any_skip_relocation, monterey:       "0d319cfba612259e187ba7d3fc76b46f945212cf6472fdedfe5afe7610e28b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbaece9735f4e55c122a6426df7e87473cc213bedfe33645d06eaac079781a0a"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  conflicts_with "gerrit-tools", because: "both install `git-review` binaries"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
