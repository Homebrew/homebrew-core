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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f21f389ba2e22503900f31d63739513f239347fa1a798a24a1d57812c0b0bcd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f21f389ba2e22503900f31d63739513f239347fa1a798a24a1d57812c0b0bcd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f21f389ba2e22503900f31d63739513f239347fa1a798a24a1d57812c0b0bcd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb22665ca96a92b9319f8fdb694b809feaf104a1cfa6ea71369e13685af6fe01"
    sha256 cellar: :any_skip_relocation, ventura:       "bb22665ca96a92b9319f8fdb694b809feaf104a1cfa6ea71369e13685af6fe01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21f389ba2e22503900f31d63739513f239347fa1a798a24a1d57812c0b0bcd9"
  end

  depends_on "python@3.13"

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
