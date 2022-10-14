class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/ea/9f/0203bb48969f433e81ceae2a04e6cc2f338a43e2f5ef1f49676667c5f314/dunamai-1.13.2.tar.gz"
  sha256 "3bb079c1a84b3dd04a20071e6c914308caba125af98bcef537cabed1a628d989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7f2cc83b23c1ef9f92b9877e4c8e5fc8dbcf04a036f254dc8884a1cd4f8f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5af321c3735c32427796c7750f380db323faba47ee3d88ae4ed081770417f71"
    sha256 cellar: :any_skip_relocation, monterey:       "df11e25b1986418320efc165f80fd8bd342d72f86934aed36868427b81329c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5f84ace779b9ac22c6b447c81b600621f635218cbe90bcca8357e78233359a6"
    sha256 cellar: :any_skip_relocation, catalina:       "f218b4696452df3888d8259bc6245dc233a4dba8ddb6b1511611b54db317b086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959c20ebc1a6178551e556995493efc00aa40c20059855e5ca1e5c092d83f563"
  end

  depends_on "python@3.10"

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
