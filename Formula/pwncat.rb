class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/31/8a/efc45ecc5e91afc76de9c56f89de99af01d575529fead6ee24331a3fddf2/pwncat-0.1.0.tar.gz"
  sha256 "4f711c3d0f22650e20ad1429a7f0c9116b930be04435e7f690746ca0e1c5cd69"

  depends_on "python@3.8"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
