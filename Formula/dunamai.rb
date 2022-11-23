class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/96/be/8bff0b3ccffe18f707841a8e7b32900637b7298cb86e6115569066688318/dunamai-1.14.1.tar.gz"
  sha256 "fc3dc52c69eb14c5374e3ce9cb68413e143f7e5983ab0b55f0c099cd36572482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e8874af64e0e883688e3bd1652685336d0d6914c7d4394173cfba6275432f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9fe9f9dd984b8437c52e03ff2f7423e961341fbf22ae8f39afbf941ee8e5fdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82dc49050bc9fa40e2bb9246b29c515831bf4b71573a5a7ce99bff23dc06efb"
    sha256 cellar: :any_skip_relocation, ventura:        "0fd553c2938009751be083c0387e5fc6e4fd16a625393884f2f44611d9df7fba"
    sha256 cellar: :any_skip_relocation, monterey:       "e91c11d29f1377c1cfe5aedbb6a13f881cae0ef278cfe3473999efbf1a53dcf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aab254de13cae0163b4fb74bf72e35613bb2842258ce51d5edb163fda5ccbca"
    sha256 cellar: :any_skip_relocation, catalina:       "19f45286947ddeb91fcfc4559677483ba6947cf230ddbdeb0ebd3c6cbd1c80e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc86b4054a2c72a80473a8162a572b2aff7a61bc9fe6724ea280c7b05176ffb"
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
