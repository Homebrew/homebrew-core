class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/9f/67/d5611975faaa5e4a920f4b19e4caccd5df0facb925687850f1e45f5876f2/dunamai-1.26.1.tar.gz"
  sha256 "3b46007bd65b00b4824ead0a1aee365fd22d0ec2b9c219497d4fd48f52860c8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1505bd0185c6472bc772b202dc098fcef4bd64e6cdcead49a0336df34df5f14"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
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
