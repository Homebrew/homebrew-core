class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/8b/ba/db6c087f044f6a753a85c0d8b25848122018ced2130061298c0c08940a54/diceware-1.0.1.tar.gz"
  sha256 "54b690809f0c56ab3085a18e15a0c3804d4a0d127f38aef0b5cf5f859d0f6639"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9d1288469164e84e042091daf65cb61637113d7e343dc8fc6c3ac95a75c4a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d9d1288469164e84e042091daf65cb61637113d7e343dc8fc6c3ac95a75c4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d9d1288469164e84e042091daf65cb61637113d7e343dc8fc6c3ac95a75c4a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fddd1640d30f4248092cf4a711f6902f31241e3e0db20a3ac962c8bb34a8fe30"
    sha256 cellar: :any_skip_relocation, ventura:       "fddd1640d30f4248092cf4a711f6902f31241e3e0db20a3ac962c8bb34a8fe30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bbb8ae111a8a2534c4df6422a6c00802b43bc5744d6c9177d97b6cda883b0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d9d1288469164e84e042091daf65cb61637113d7e343dc8fc6c3ac95a75c4a1"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
