class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f132913229a824db2a1248037c6c68b292b86e25b20e9128940e84b6355ffac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c840313e2c51eb693fd53bb0e74b2c5a480df3e87a268ed8bf9d84b36f0724eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56254db8f4bafdc6ef946b5b3e56bc6afde3caab945abe60b67bb812eb5f99b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cbf066c25cdd5cd4c06fd2c2ffbf3ca2022654dbaaa9949462768408e38ca13"
    sha256 cellar: :any_skip_relocation, ventura:        "64c8eb03905ca67c27b5ef424561457d628fbbd8a6445ba04fe5f0f9408f8560"
    sha256 cellar: :any_skip_relocation, monterey:       "a36ae1e591e705bca710102ce9cd1de8a25d624ab8978ec0e5f84879af798db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7337c2a46eec782bcda2cb48ae2d1419bf14da25e6c5b32af324ad22a38f75b6"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/cd/51/7355831d8e1cee8348157d769ccda8a31ca9fa0548e7f93d87837d83866d/sh-2.0.6.tar.gz"
    sha256 "9b2998f313f201c777e2c0061f0b1367497097ef13388595be147e2a00bf7ba1"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"gitlint", shells:                 [:fish, :zsh],
                                                        shell_parameter_format: :click)
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
