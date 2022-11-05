class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/ea/9f/0203bb48969f433e81ceae2a04e6cc2f338a43e2f5ef1f49676667c5f314/dunamai-1.13.2.tar.gz"
  sha256 "3bb079c1a84b3dd04a20071e6c914308caba125af98bcef537cabed1a628d989"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0850c17af9cbad57ab4611741dadb72f6cd2559eff2ba8e0a5c14817823b827d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c82ea726f02a842d74493e90d9566ff69d37a1182ee988b25c21f4eb240463e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d1e427ec91078c57efdaf7721475e34767a0213eea845733bc465630f53c533"
    sha256 cellar: :any_skip_relocation, big_sur:        "95ca5460d458824b3acc034594b0f947eaa06dd4839ecef8b15838d9ad6d9c12"
    sha256 cellar: :any_skip_relocation, catalina:       "d900694db5b62d116ba578108769463721d4d3e196bed84fdbd156acde01fe10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5072f604983ec21eb721eb613f8d55745346a478da4f5b7ca358bf4f225aba"
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
