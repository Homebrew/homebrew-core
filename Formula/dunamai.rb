class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/ea/9f/0203bb48969f433e81ceae2a04e6cc2f338a43e2f5ef1f49676667c5f314/dunamai-1.13.2.tar.gz"
  sha256 "3bb079c1a84b3dd04a20071e6c914308caba125af98bcef537cabed1a628d989"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a1f60f406aa4b3075b66da7e1324d202a691f6edac42d7a09a3a5eb5a710e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32dc9a51081509b0546d15116c051c33066f455285e664b26ea9e845dae02ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "f53a7498d428a87fa14a3df2fb14e0c329a13b87a587edb8fa6b0d0876e2d4a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "388454a8f4c91719e6a3c92f465f450bc449d536f07407264285fc4a46298bd3"
    sha256 cellar: :any_skip_relocation, catalina:       "fd4271271768dad024d38cdc81b867a547fc26f232d1502a41ef5aca8efa50e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e076a4f06aa7278da76c4493dfc4639ec83c0ca43d896603132aa9994ab35579"
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
