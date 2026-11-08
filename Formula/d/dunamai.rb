class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/9a/f7/11694756c174d9552a97a9ebb191bda5f46a4176700d9d2d698182d9f75e/dunamai-1.26.4.tar.gz"
  sha256 "13b2b2af2af44158ef02f22ae4ff1b280b221c2760bd0f5891ef58b884678754"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf616f53af0ab4a1c429cc1164b8b2b40e788ff75b114bb1aabddd4c65953c70"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
