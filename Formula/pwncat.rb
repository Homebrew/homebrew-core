class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/e0/cd/f7c7a2d468fdf8355c574ac65f189da87a469c393ec704d8f3fa83613aa5/pwncat-0.1.1.tar.gz"
  sha256 "62e625e9061f037cfca7b7455a4f7db4213c1d1302e73d4c475c63f924f1805f"
  license "MIT"
  revision 1
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6e3393a6b6e754382d49770b5dc053e70e09e9c63a64bcf92c0053bd8d6e777"
    sha256 cellar: :any_skip_relocation, big_sur:       "7162c1625bc9a1d18d0cd0d11d16200dee5749d37c91e1f16281eeb4b1e1b78e"
    sha256 cellar: :any_skip_relocation, catalina:      "7162c1625bc9a1d18d0cd0d11d16200dee5749d37c91e1f16281eeb4b1e1b78e"
    sha256 cellar: :any_skip_relocation, mojave:        "7162c1625bc9a1d18d0cd0d11d16200dee5749d37c91e1f16281eeb4b1e1b78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ef0e8c6c4a35f60a2149569a2e5dafdde8b76edf10f53a21672318ee582fb6"
  end

  depends_on "python@3.10"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
