class Percol < Formula
  include Language::Python::Virtualenv

  desc "Interactive grep tool"
  homepage "https://github.com/mooz/percol"
  url "https://files.pythonhosted.org/packages/50/ea/282b2df42d6be8d4292206ea9169742951c39374af43ae0d6f9fff0af599/percol-0.2.1.tar.gz"
  sha256 "7a649c6fae61635519d12a6bcacc742241aad1bff3230baef2cedd693ed9cfe8"
  license "MIT"
  revision 4
  head "https://github.com/mooz/percol.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da475ab49df0faeb44eea45669d160a11113925d29fa3ccc7cc20e8500eea27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da475ab49df0faeb44eea45669d160a11113925d29fa3ccc7cc20e8500eea27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6da475ab49df0faeb44eea45669d160a11113925d29fa3ccc7cc20e8500eea27"
    sha256 cellar: :any_skip_relocation, ventura:        "c416bc3dcab1ee767c0b63f5766411bdc48f8042fa83b8068bee178ff16df39c"
    sha256 cellar: :any_skip_relocation, monterey:       "c416bc3dcab1ee767c0b63f5766411bdc48f8042fa83b8068bee178ff16df39c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c416bc3dcab1ee767c0b63f5766411bdc48f8042fa83b8068bee178ff16df39c"
    sha256 cellar: :any_skip_relocation, catalina:       "c416bc3dcab1ee767c0b63f5766411bdc48f8042fa83b8068bee178ff16df39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ae72d152ad18f4f8565828e7da87ab3ad7839c8f59021c4fadb60ab4e59737"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "cmigemo" do
    url "https://files.pythonhosted.org/packages/2f/e4/374df50b655e36139334046f898469bf5e2d7600e1e638f29baf05b14b72/cmigemo-0.1.6.tar.gz"
    sha256 "7313aa3007f67600b066e04a4805e444563d151341deb330135b4dcdf6444626"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"textfile").write <<~EOS
      Homebrew, the missing package manager for macOS.
    EOS
    (testpath/"expect-script").write <<~EOS
      spawn #{bin}/percol --query=Homebrew textfile
      expect "QUERY> Homebrew"
    EOS
    assert_match "Homebrew", shell_output("expect -f expect-script")
  end
end
