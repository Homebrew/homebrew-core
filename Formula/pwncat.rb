class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/31/8a/efc45ecc5e91afc76de9c56f89de99af01d575529fead6ee24331a3fddf2/pwncat-0.1.0.tar.gz"
  sha256 "4f711c3d0f22650e20ad1429a7f0c9116b930be04435e7f690746ca0e1c5cd69"

  bottle do
    cellar :any_skip_relocation
    sha256 "effc23c8094a031f9bc1964adf5f5ab050500b86726c948f81fe67d35f5e700d" => :catalina
    sha256 "c140bcf0cca3b1b2176e762dbbafb1c02f831c032741ece1dda4f95fa0ada397" => :mojave
    sha256 "cc5dcb70ed1762f24f7d0511b74b2f119403f2bf8bc463aec844b8701682e2f2" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
