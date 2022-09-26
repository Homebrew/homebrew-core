class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/95/ad/4347d04bfc330951d00bc192b40f6dddc1d8929a9a2fbee77e9ab6533cff/dunamai-1.13.1.tar.gz"
  sha256 "49597bdf653bdacdeb51ec6e0f1d4d2327309376fc83e6f1d42af6e29600515f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b19eefe9a6ed5b032b747b331c98a570f918074a97e9e42f3b107599bc99f8e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dca46b3905046f7d3320095679543d6d49027e5b42a1e2ff01458dd9c0ea2451"
    sha256 cellar: :any_skip_relocation, monterey:       "43263b40dfeceff86e5ac494850255faaf7b29dc1f95767fb7ea7c3ef29d9b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "227178d50d6a1825ac6e1df0d236abe178b95548528a75190c3e79cb0e3c1703"
    sha256 cellar: :any_skip_relocation, catalina:       "7174aba2a5440d0b6b4d058cb8e0f17b85a3a62e95ad90af399f8c21cd707c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4995c4dd5d6293f8c823c904e3ca0eafb8873cbbdb80740ea8efbf1c579c68cb"
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
