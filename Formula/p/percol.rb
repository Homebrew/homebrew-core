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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5597a464a6e0aba9ecd7acaa292993eab3902152f0185bc0d13d8694df95976"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66f845e8b6002bbe556ae966499d5bf7c480f4b9f25a72397e9aae1fdf4e355a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599c1c89a45465582c1ceb50dc104d75682e80d88df94dfd22c26fe128fb859a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d9a119d3416d356128749d89215fbb6d6c44d7b6eacd1a6a0f29b735097422a"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc1d46ae856efe5b417726781c1e517473e20a39597c1b8a57b0d8e8fe2259b"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a946699e0bd20fe73cb5c9aea58c77204330cda4cedd58917fd8ed4ff9fd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced2fa46c94783273b276e0b057239feb898f041a6525909e2aa14f82f07db18"
  end

  depends_on "python@3.12"

  uses_from_macos "expect" => :test

  resource "cmigemo" do
    url "https://files.pythonhosted.org/packages/2f/e4/374df50b655e36139334046f898469bf5e2d7600e1e638f29baf05b14b72/cmigemo-0.1.6.tar.gz"
    sha256 "7313aa3007f67600b066e04a4805e444563d151341deb330135b4dcdf6444626"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
