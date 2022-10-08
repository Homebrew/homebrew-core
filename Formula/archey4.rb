class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/7e/6b/ccab7e74a8c9cf79a82912508d741bbb78219c307cc0daef219c2dc802c9/archey4-4.14.0.1.tar.gz"
  sha256 "349e462d530491f17526441261bea3d0cd1b2430b69f5eaa03054961b918e1d1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2df87e8a12545b3d5426b249eccf846e94efc2503b62248cca2cf9d23068ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e81d376f91713310fef993d5849364609053802d400cc7a844b2abbedb9746"
    sha256 cellar: :any_skip_relocation, monterey:       "14a51af2357fd9bef1acbc90f078b03344e4547eedad6250e81f3db6237297cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "93ad00b55adbc5da1d6ea721c7664c759e32ccaaa04f130f3b5d6cde1e504c21"
    sha256 cellar: :any_skip_relocation, catalina:       "0321b8a89a447f16b8d2a9e8fe41ec70e5ffef6fe281a0e5633793b9aa5024c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7d895a1cd245fa03d0a205eb6611dba3e731e77497f0eaa163734a1333569d"
  end

  depends_on "python@3.10"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
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
