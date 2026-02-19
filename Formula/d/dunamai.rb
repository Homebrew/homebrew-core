class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/1c/c4/346cef905782df6152f29f02d9c8ed4acf7ae66b0e66210b7156c5575ccb/dunamai-1.26.0.tar.gz"
  sha256 "5396ac43aa20ed059040034e9f9798c7464cf4334c6fc3da3732e29273a2f97d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf103b47db3787e16f1e68c1b5313197b26fd46db7c25302f62ab855c0fe30f6"
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
