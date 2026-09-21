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
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "2c3890df22100cdc7677b196d924237649a0d7e3af5d0c26fa52e012cdcd1dac"
  end

  depends_on "python@3.14"

  resource "cmigemo" do
    url "https://files.pythonhosted.org/packages/2f/e4/374df50b655e36139334046f898469bf5e2d7600e1e638f29baf05b14b72/cmigemo-0.1.6.tar.gz"
    sha256 "7313aa3007f67600b066e04a4805e444563d151341deb330135b4dcdf6444626"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = "Homebrew, the missing package manager for macOS."
    (testpath/"textfile").write <<~TEXT
      Unrelated line
      #{expected}
      Another unrelated line
    TEXT

    require "pty"
    PTY.spawn("#{bin}/percol --query=Homebrew textfile > result") do |r, w, pid|
      w.write "\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_equal expected, (testpath/"result").read.chomp
  end
end
