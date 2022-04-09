class OpenAdventure < Formula
  include Language::Python::Virtualenv
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.10.tar.gz"
  sha256 "e0fc4c5d1aae0f27ace48af7cc45c9bde582a0eb305bdcb95e31b1310f32daa1"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359a060e1126c9c92249c695d873a69f32b64078f912d4a59bed24ba679e1678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe7240131a460a308e8740cd7500ce914e661102f689e28c05998bf1858adc8"
    sha256 cellar: :any_skip_relocation, monterey:       "744e6d786d9c1d113a0b9f0a843f144082a71856cddbe11919b8dccfd26ce738"
    sha256 cellar: :any_skip_relocation, big_sur:        "0440f57ddba9ae3272b08ff64837622cafa7ebded06015199370528b4ff09865"
    sha256 cellar: :any_skip_relocation, catalina:       "f1b5692c2de3a40ee6790bc88e33a31bca0d99eab3e6272f62540821a5890acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ac0518e04137c3cdb6ff8c9bd6665a8e5319ea7677c7378704ab4d5c0415ba"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources
    system libexec/"bin/python", "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
