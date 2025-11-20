class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://github.com/lilydjwg/pssh"
  url "https://github.com/lilydjwg/pssh/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "dfe1b898e483377213b44b8316a81fd6e1bbe427e1607e76be18366071c04c85"
  license "BSD-3-Clause"
  head "https://github.com/lilydjwg/pssh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42ee0775a8a57ef28617fb582456c2a59e53620e2fa332e2de2bb970e33b12da"
  end

  depends_on "python@3.14"

  conflicts_with "putty", because: "both install `pscp` binaries"

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("man/man1/*.1")
  end

  test do
    system bin/"pssh", "--version"
  end
end
