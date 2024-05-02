class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c6ecc1155edaf131229b4419e6ca8271e32896fa091bbb33e6449bad4f51513"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac29db679db5b09dc6a5ebfa01674c9017c4fa8fa883581423de518b8f34d56c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "927f4dcd92b7cc5ab0a4e71aec0b6749e66b95c26df587eb09bc743ded817358"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f01d968d9545f38b443b985cec9315ba768b925ab5dad7a74c114eeaa0776ba"
    sha256 cellar: :any_skip_relocation, ventura:        "16a5f7e354160529d334f8cc196f59b70d9e8508a0938f94ba2dc87bd786ca93"
    sha256 cellar: :any_skip_relocation, monterey:       "4c1ae92e608c4b6c27d983d9eec19b3dbde35892a5e3b2412b4206a16f22f6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198d662c21378d2a4b6e0d4979de37d42a8c7b8801d024be822c26d70be4d72f"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
