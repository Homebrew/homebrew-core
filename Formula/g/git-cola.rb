class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/d5/df/41ebfbae6c317da0569637bf16c74ace7e6dd729c075677fff09b8ca5db8/git-cola-4.3.2.tar.gz"
  sha256 "5ae4e7299e4f455f162dc8ce79cdf351a80da656ac7acb58459c19691b04e83f"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33678584870160d2f3613872bd1d1a8b52b7921e273b2111b9fa98748c4e6987"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b2068b9aeeb7b411d9ee29f7c9e96637cb4574d73b65964d76359f7bcfb8c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e03d55101ab978f3e7bc2edf169e9e68ed0ff49ead0ed174d6b18b0a63d905f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa82169f18dedcf1dd83309d57ab7518ee1f665fe4c564ea28066ba1187c2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "be5ec2a4fafbcccc67a03524627e3a8a810270bfa332b72f88269f79f9f3fdb0"
    sha256 cellar: :any_skip_relocation, ventura:        "c25c8646fca823cda352b50cef673df8834a7c27e411b4627544d95bbe5c6041"
    sha256 cellar: :any_skip_relocation, monterey:       "237dfe103071dc7a7f7c0042e20ae9e4fdcb3cfa2dc2283f8c5eb2f97fd64992"
    sha256 cellar: :any_skip_relocation, big_sur:        "0827100bd8425d2c811eef3511687f64f58a32d53cc039509ed2323896b39160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56986142690b372507b4ec22ee53142fae8809d5ab6ee51c239c4a4c5c7552fb"
  end

  depends_on "pyqt@5"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/1e/67/b3099c5f646bb42011a30c05f673e84cc82a72fbc1f9f2c271598ac97283/QtPy-2.4.0.tar.gz"
    sha256 "db2d508167aa6106781565c8da5c6f1487debacba33519cedc35fa8997d424d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
