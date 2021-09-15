class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/e0/cd/f7c7a2d468fdf8355c574ac65f189da87a469c393ec704d8f3fa83613aa5/pwncat-0.1.1.tar.gz"
  sha256 "62e625e9061f037cfca7b7455a4f7db4213c1d1302e73d4c475c63f924f1805f"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc906f569c1db49247320a2c5d9e27f26880d3041c6ff2f1b178fa5b1aa6a586"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe18e3f9569fead9b8d60a719798afa0cda35626e6296d7a8917dd1d08812b92"
    sha256 cellar: :any_skip_relocation, catalina:      "6aab31b67601d8e6c3bd584d8f4f264843ff8dab112eef4b31ae5896e6ba653a"
    sha256 cellar: :any_skip_relocation, mojave:        "ea6514ac82a8edcbe9e2fc1cd2077baa1b4312979f39c84359ba7794822c0a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee0a58cef0ab5f64059cd262a154c5da65d96be6c7d886a12d5a5912b9df6fe"
  end

  depends_on "python@3.9"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
