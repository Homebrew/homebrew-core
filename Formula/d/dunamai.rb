class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/77/c8/845bdb9167570937cada51b586393dded1e77c56db458f350a671c4f1ab9/dunamai-1.18.0.tar.gz"
  sha256 "5200598561ea5ba956a6174c36e402e92206c6a6aa4a93a6c5cb8003ee1e0997"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6945b4438559c6b638924175abf2a2ea82e9e26287680c69e96a9ee38e9a93fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd8af031e7a9a11059b7fbb3a35deb3b6ab361968a056d118ed07fd8cd9b693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb3b6232125c18a83e656204244f0523734366bc25c30962a9eb49447fe7399"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf8ab1ccada6c06e052804d4ec9007bac080710a97b622c65b6c5ac351f6e62"
    sha256 cellar: :any_skip_relocation, monterey:       "a4de1854607b52304e0ba638ee2f056285ba61c45f609436f3e6816bedfea73b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e745307de017055f29c996470a9929176589ecad846158dc193fee59e104888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd88fccf7512658a531acd4c1c21c7183a74a50ebcb59bc1699c6fa5f8f674e"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
