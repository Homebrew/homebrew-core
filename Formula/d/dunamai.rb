class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/87/10/a31f42c4c97f6c2af69d5084346f63cee694130bd18be2c664d23cb2ebd8/dunamai-1.19.2.tar.gz"
  sha256 "3be4049890763e19b8df1d52960dbea60b3e263eb0c96144a677ae0633734d2e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc6201362733b38c8b205d233c44e32d476e784ed65598f1ee8167f152462d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da09863b7936aeeb1179f2cac85c3496349a1729b65779cbc952a07f529c146a"
  end

  depends_on "python@3.12"

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
