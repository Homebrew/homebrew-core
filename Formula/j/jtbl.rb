class Jtbl < Formula
  include Language::Python::Virtualenv

  desc "Convert JSON and JSON Lines to terminal, CSV, HTTP, and markdown tables"
  homepage "https://github.com/kellyjonbrazil/jtbl"
  url "https://files.pythonhosted.org/packages/9e/7c/b21f3383ca611b56dbc281081cca73a24274c3f39654e7fe196d73a67af6/jtbl-1.6.0.tar.gz"
  sha256 "7de0cb08ebb2b3a0658229a8edd4204c6944cbd9e3e04724a9ea235a61c115a5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36c946d8efc31ba345e4b8933c3b460034df431373eb632837778ade53378ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36c946d8efc31ba345e4b8933c3b460034df431373eb632837778ade53378ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d36c946d8efc31ba345e4b8933c3b460034df431373eb632837778ade53378ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "6070ec308bdd9b1030b07c7dd4846bb5b09bd268879b21aeeb352453d1fe0f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "6070ec308bdd9b1030b07c7dd4846bb5b09bd268879b21aeeb352453d1fe0f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc3fe830e2fe701963c723a4fdfb96e8a9acbedb5a1ec4588b66067466d7172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36c946d8efc31ba345e4b8933c3b460034df431373eb632837778ade53378ec"
  end

  depends_on "python@3.13"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jtbl.1"
  end

  test do
    assert_match <<~EOS, pipe_output(bin/"jtbl", "[{\"a\":1,\"b\":1},{\"a\":2,\"b\":2}]")
        a    b
      ---  ---
        1    1
        2    2
    EOS

    assert_match version.to_s, shell_output("#{bin}/jtbl --version 2>&1", 1)
  end
end
