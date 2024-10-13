class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30161c381edbde1a05ba7ee432f9533376240d025bab8db2c08c2efd44963678"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30161c381edbde1a05ba7ee432f9533376240d025bab8db2c08c2efd44963678"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30161c381edbde1a05ba7ee432f9533376240d025bab8db2c08c2efd44963678"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98ce2ef751cd800fe944900ca6ba267dbbef0d65bbb8ce9141f069425e41ba9"
    sha256 cellar: :any_skip_relocation, ventura:       "c98ce2ef751cd800fe944900ca6ba267dbbef0d65bbb8ce9141f069425e41ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa6e49310aa8a310ffefc2fce7de4c134542b083ee86e2815a1ac8ce2633301"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
