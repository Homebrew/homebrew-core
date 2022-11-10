class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/05/d8/2a9778c3242e7c08eedb0cb77c7202cf35c0dcbc048476f824e8a014c4c6/dunamai-1.14.0.tar.gz"
  sha256 "002abe8b9273e61c03d85918181cf6f3a42940cbb99bd93c825242f3712a1331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a34a0dd077e015f46973a5d6517595eef9c4e9284f04403e7137752b04d85c98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed016e4dba1fdeb5680609ee613aed1095cced5c89aa479d14a067bc9fc36b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "337f7d29d13db1d4109405d73bad1911fbbb1ce58a9fd2f595db7282c5e4479f"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d8df7a436b5cbe8e997dc7e37c01574e6bd39c5ec35539d37e246494200e7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "475c399dd0e0a54e2261ef33feca103ccbc10140050d5e5f00256341d044db93"
    sha256 cellar: :any_skip_relocation, catalina:       "a417e06f27d75580d9018288a2f7a8beb08f2f8f48ee427968357eaa671c5cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb503b879844b0b428d2ec51c639598f2138ab8546d0611084cbc9e3f9a3380"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
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
