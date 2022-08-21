class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/2d/e4/d92c4e1ac3115575c9a8d528625adf08ad3a980f8236a34486e49a7ad381/dunamai-1.13.0.tar.gz"
  sha256 "5bf9e5baaa673b692a9613e4961b18b6d2d9743412f7bbcf4a39c84a979f47e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65789cf29042f5c43195bf35033f4bce6b384b32db47c290610948295ba7383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aa812c4b3d05032aa00926af661247d93ac67871b0cdf562e1c3248d3305c22"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c32577df9cba08fb81fd3d29f8cb7b80cc938201d3bb2ee0d48974697332e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de7ed6bb9096a76467cff5861804e62a801978c27c741e509af5540b9bb81fe"
    sha256 cellar: :any_skip_relocation, catalina:       "f3548a580fa4a2f6a5762ae72c480c171c887494f75b8b4609082d8cbc3a0d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d3d2137e12f312e5d0159a3061ec16a56bd4398b4cbb10e7fb44c3946713ff"
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
