class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 5

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01903f453e4afc999a98345cff835cdc781a8cec808fe49aee80d90f0de84171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85381b7751afaae1d193207777a06aeef66570058ba7bd9fb60b8fda1227fa77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05068b7cbec71870bd259fd31d0fcb779cbee043498cdbd418225dd3113cff5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e4bd9fa7f24ac7b95b6fd355554430611d0f3b6bf3ac39001fddb000bddc60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e9e115b01e92086c1c1ff02a4f2cb5a0943fbb60adc1a10fbb9483d4647139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1468f8a2747ba5d8576f0d4263ec8160b68646490c45b5e53287e4e639713139"
  end

  depends_on "python@3.14"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system bin/"keepassc", "--help"
  end
end
