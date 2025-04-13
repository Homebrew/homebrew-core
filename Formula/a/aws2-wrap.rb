class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/6d/c7/8afdf4d0c7c6e2072c73a0150f9789445af33381a611d33333f4c9bf1ef6/aws2-wrap-1.4.0.tar.gz"
  sha256 "77613ae13423a6407e79760bdd35843ddd128612672a0ad3a934ecade76aa7fc"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d80eae08463ca93b1d39861c28412fb9547db8a86d5041e338a72da501f969fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d862292e6dead768c28d279476e634381d6a27c3efe256600efaace68faaf65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c98df6972dc8b0cd6fa2faf431f3f39316b5dd86e40b6406600c9bf9369aba08"
    sha256 cellar: :any_skip_relocation, sonoma:        "42988b57040c6a9174d83c312d76336a7f293bf92fe1e727ad5bd7c661d9524f"
    sha256 cellar: :any_skip_relocation, ventura:       "433bad07f827a41b9e9712c7c71cc90fc98c980d4cea9a75feeb1ca7b538a90e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc1013b4756e0a79e525367725c0218edde1e9c2ce7850c120728afca5e8bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b0b56d7d195178f4c4e53c5171e0ec0fcecbea18537a4c2692854d38559098"
  end

  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"

    assert_match "Cannot find profile 'default'", shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
