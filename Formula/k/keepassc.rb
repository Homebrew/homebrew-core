class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 5

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5d68d75a32b6b99b746bc2a391fa4b0de0ae57634715d3fb34d8fcccb6f14d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bc6becf86b14c06d92cd8ad72d3c56678813cc8372dd4107b9d2437b09b2c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1dc15687e0e1a0cf07e05a70ea58e24c9c30737b180583cc63f016591c9a0753"
    sha256 cellar: :any,                 arm64_linux:       "9a2eb402435a67eddbeaa81a860bf9c31b8815b2208e2a5e9ce26229e9007738"
    sha256 cellar: :any,                 x86_64_linux:      "62c9852cfb3dde879e9d38aad2b0a614ef157f746e40d111894dce03e6a9ad73"
  end

  depends_on "python@3.15"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/4c/25/214ea825a9031f5af2c8b2506ee16701a2560d4712165dd00098dd527bcb/pycryptodomex-3.24.0.tar.gz"
    sha256 "0428f19f13452c6b89bbaf2c530f84f369873811dfa77f0cee0da4f40fb0474f"
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
