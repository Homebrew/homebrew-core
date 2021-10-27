class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/55/21/19a74d9ebf7954eebd08e4afa4c6aaa9bfedff9b8bfbad8e94925458be96/archey4-4.13.2.tar.gz"
  sha256 "5a98e7681d715e445f0bc1b86ab13fea4f379ecbf89d506e27a707d02384cf00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e824be83193a74a0d3b5ebed70583a941ee470514834a70c4ae0287d5dd6893"
    sha256 cellar: :any_skip_relocation, big_sur:       "e848273ecff0d37d6902db78fd668121e3fc6d474772b7b7ee0da3592171dc10"
    sha256 cellar: :any_skip_relocation, catalina:      "317f1ef273ecca9613f395ff13e64351d63f7f4626fd0b638dd2ed66bec831ba"
    sha256 cellar: :any_skip_relocation, mojave:        "8f277515b7d8d121480d26afa4cf671174e094f17aebd9babc06df1642577158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016fd46d432126417712bc146acb31a2087dfb96919ae536426afd0c9d361c05"
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
