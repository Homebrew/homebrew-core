class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/db/06/45e8c09c600c0647aa549b66e08f8dcf15203f81efbdd8f0bf4a784bf8e2/archey4-4.13.3.tar.gz"
  sha256 "8c81ad0267d6d4689357d27e274fa142e10a8e619184bfafd9e57d9a8a720848"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4103fc5fefb64374aa0b0a298b4c6cfd4a3be3d17cf54222d0c77a10c15a56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e824be83193a74a0d3b5ebed70583a941ee470514834a70c4ae0287d5dd6893"
    sha256 cellar: :any_skip_relocation, monterey:       "8caed1e145509feaf3da6fbc74452374dd88109a665a61ef17d7e14007fd030c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e848273ecff0d37d6902db78fd668121e3fc6d474772b7b7ee0da3592171dc10"
    sha256 cellar: :any_skip_relocation, catalina:       "317f1ef273ecca9613f395ff13e64351d63f7f4626fd0b638dd2ed66bec831ba"
    sha256 cellar: :any_skip_relocation, mojave:         "8f277515b7d8d121480d26afa4cf671174e094f17aebd9babc06df1642577158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016fd46d432126417712bc146acb31a2087dfb96919ae536426afd0c9d361c05"
  end

  depends_on "python@3.10"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
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
