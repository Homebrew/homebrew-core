class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/75/8b/6df640e943a1334bebaf96e0017911763d882748e8b8fd748f109c8c3279/doc8-1.0.0.tar.gz"
  sha256 "1e999a14fe415ea96d89d5053c790d01061f19b6737706b817d1579c2a07cc16"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a35e6213f12f7da625eae2c78b59b2bf03da6a94efdba67cec7125425769ba02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2bf743768fd3cb7d32c36f339c09602db87a4add2f53bc5517d56f5a4d5fde0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "834c488f7fa94a9fc92b5622e91af6fc02bc0fb8161074040e3936e66de7622b"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ac76ac677bac9f95f7923eef4eb4f6f3599377dfc59cd1f889b59ac3d5d8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba07a0233f03adc42b62e7db510355177b89d5fcfaa44c221b2ceb8495da14b3"
    sha256 cellar: :any_skip_relocation, catalina:       "73bd19e07cb54c1267411ccb3621c0b82f0c8e82aa0976bde51a8a05adf67596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8838360ce692d41c55ba7847ea8cff057c975719c3843348cdeab57f0441bc0c"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~EOS
      Heading
      ------
    EOS
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
