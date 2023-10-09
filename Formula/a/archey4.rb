class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/b3/76/21850b7c2b5967326c13fac40a60e9d49295e971ec5b5398780da9d5ee04/archey4-4.14.2.0.tar.gz"
  sha256 "afbc9f66e0ff85bfff038b9a8a401cb269a28a9024b2ce29ad382e07443eae9d"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2fda1d85c43e769d8e76074a379251c2ce852f3c80c40995250018fb09b083a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8069e7847887ccc012472a2195ccd2b5f013da79a728981af9393439cff3b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b945fa5bd63c3ade3a8f75aafe4a7a10710299b19c142167da603e24a6c87fea"
    sha256 cellar: :any_skip_relocation, sonoma:         "dee1c6ed8e230f1b32bd7e4c0a81519a109653a0f9fd0a0121f13fda2c5e1dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "ed18454fece28e67caefb5188fe0ac2924d9a75f2aed23eae00900fed694f4d9"
    sha256 cellar: :any_skip_relocation, monterey:       "19e4e3528875765e5d7df6d5f24fa12c1df66baac1a9dd015caeea756e7e08ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b65d6505774745b695b3797f978e68822395316aa0d053ac5157aee461cff7"
  end

  depends_on "python@3.12"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
