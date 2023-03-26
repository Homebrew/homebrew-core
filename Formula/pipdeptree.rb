class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/86/62/309b36c833a99518d35998df58271a15756f847ed66e2e46896d7df49f53/pipdeptree-2.7.0.tar.gz"
  sha256 "1c79e28267ddf90ea2293f982db4f5df7a76befca483c68da6c83c4370989e8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1434db9adf6670cf3307dd797dc798b6e06a64c38c88730949af2771c0eefbb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c1183ec411d054efa04db5d99861d3fb7b47af530c1f5b29834b00e53b67303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6386b7952ce5e425eafb69f70c47f0faa8b9be95c01521b476ee1c7100a8d6ae"
    sha256 cellar: :any_skip_relocation, ventura:        "def225d7b30c71e58f2cce58f6b8b9f9d0f84ce31981ec4e21c16f76c6242923"
    sha256 cellar: :any_skip_relocation, monterey:       "69aeaa7bb152cd2a19fa96038693a52142c7dd6631b1b8f8211b250d42fdbec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a6f28b7d792995b8f5fc33214edaa90bbcbffe658b1c826f541287fb75ffe14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7a051c0fde9e1704368046cb5c6c1826e3c3aa110bc705f33600849b1afd1d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
