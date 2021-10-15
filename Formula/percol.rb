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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12ac8e4fb2d128105a336fb66f03e5c4b2138f3e2d0008f3caeb5b9361286d83"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1d437af31e6c2c6b2fcb7fa5b6d7a81c1cc5014e647bf803618f1421d7b53c2"
    sha256 cellar: :any_skip_relocation, catalina:      "3ff2691bdcf6ec23e6a6714322591e95361e0d257672f85bbf0549dd9d3819e7"
    sha256 cellar: :any_skip_relocation, mojave:        "5bb5d60ccdc9296979b17f056377fc73c9d970580654e342e89b0f7e2a23154c"
  end

  depends_on "python@3.10"
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
