class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/31/8a/efc45ecc5e91afc76de9c56f89de99af01d575529fead6ee24331a3fddf2/pwncat-0.1.0.tar.gz"
  sha256 "4f711c3d0f22650e20ad1429a7f0c9116b930be04435e7f690746ca0e1c5cd69"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4c25ffa0c2a969ee67ecbb252c841471c5ea9e2ce87e581c130ec800db482b51" => :big_sur
    sha256 "3858b6511e81b5b8cee59724213d438f042f3cc80e3d87fb4eaa7df6771dd326" => :arm64_big_sur
    sha256 "192c19f127e900be34ca58bc3b7dec8b2fae412e53d2613396233f9e3fbb6123" => :catalina
    sha256 "5eedc0f7cdfa07a82325e09c5a3bc37e7250ad1fc87f48062c99a3a21f5964ac" => :mojave
    sha256 "9448463d98056aa3b6049f00261fea896e2a16712407f8c10fdf61d9d82dd61b" => :high_sierra
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
