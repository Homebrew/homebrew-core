class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/a0/fe/aee602f08765de4dd753d2e5d6cbd480857182e345f161f7a19ad1979e4d/dunamai-1.22.0.tar.gz"
  sha256 "375a0b21309336f0d8b6bbaea3e038c36f462318c68795166e31f9873fdad676"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, ventura:        "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, monterey:       "4c78c570e217fdeee758c38b7e3775fd210db8ae69ffec4ba93c31066e4ae822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bc06434769c714e9a61ce3e7a1548e13940f3bd4763ea5a40ed4c5b1d30bc5"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
