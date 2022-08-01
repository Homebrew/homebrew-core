class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/a6/12/0a174f329c980b62cf2873ccd2c9d8bacb9c51737cbf6c3481e2968860da/aws2-wrap-1.3.0.tar.gz"
  sha256 "8a24605c6fb073e4ffceb63000fa8acda8a1a4860807b16c9279bc64cf37baff"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447b4a780d2e6fce4f6fe67bfb2e3a43809a9fc843d5b218b7de5997332c40e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b885f4d7cf184d10a47a1bc6fad35da831b235bf7c06d1c23315693ff63635"
    sha256 cellar: :any_skip_relocation, monterey:       "5438ecbfe84a4bfc3082bc863703dcc4bab9e8bd235d34c43f3320d66c4490f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5369b9fe765f2f118698a544733d0bd1432f3f4f8df6a5bd2963e4f6fd1268da"
    sha256 cellar: :any_skip_relocation, catalina:       "4981f763b47de75876d6aac602d6896d67bcd04c8d2f405b07957cf9ba235c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4266cd968d613d83489517cc5cc38d87ad5da586ea5eb10671d288b1637d134"
  end

  depends_on "python@3.10"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
