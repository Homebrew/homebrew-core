class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/a6/12/0a174f329c980b62cf2873ccd2c9d8bacb9c51737cbf6c3481e2968860da/aws2-wrap-1.3.0.tar.gz"
  sha256 "8a24605c6fb073e4ffceb63000fa8acda8a1a4860807b16c9279bc64cf37baff"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0178b4f7739118632776439b7fdc3f0ce3607bbe3889a19a7a3d8d4c46441dca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b15d61c8f2c14c925bd165c3a6934e5be7ff3ed0e05dda1883a2ad98ee1c313"
    sha256 cellar: :any_skip_relocation, monterey:       "92e602827c4450fb6be70ce0d0879f5e1130805a5d2bc9d227b3de0840a3d5e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad904e5b1c7c2084d0eb98b35d157cf0223e86c09bee23b0e488ae2e7f142fcb"
    sha256 cellar: :any_skip_relocation, catalina:       "db1cdb2e47c366eec759f992a7066be610fcfed66abc4017ab4b000a23185d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e437c57a58447a6af2899ec122bc453078944ffb63ed066ea4d2c2e51fc283"
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
