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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72687e52eb42ed6c6ad1b6ce908a389f1c5ab3297518f04dd8dfd45522993c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "252ca2240639e6f32b9c1d948471276bd70d3436278e03124980e6fdf6970cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f3add6c45755500601ef7da8a8aaddd1c6fcdbef72c3f5b845eae73f83ea53"
    sha256 cellar: :any_skip_relocation, sonoma:         "58c8e5428cc4f090748378ef6ddcc72ab5d63daac3da74717950bb0587efa217"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6477180e64befc85d9bda592502b13e43d60f57b629ad793468f11134e32be"
    sha256 cellar: :any_skip_relocation, monterey:       "0725e41666d33aec48d5f16b8e87dd807b60f5592aefbae292ee0a12edd6c993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ac024a06a551d9f47c58ba662714ceb6014aea8ecf20b74482f24479669d88"
  end

  depends_on "python@3.12"
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
