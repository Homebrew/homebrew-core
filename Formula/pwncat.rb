class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/e0/cd/f7c7a2d468fdf8355c574ac65f189da87a469c393ec704d8f3fa83613aa5/pwncat-0.1.1.tar.gz"
  sha256 "62e625e9061f037cfca7b7455a4f7db4213c1d1302e73d4c475c63f924f1805f"
  license "MIT"
  revision 1
  head "https://github.com/cytopia/pwncat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3858b6511e81b5b8cee59724213d438f042f3cc80e3d87fb4eaa7df6771dd326"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c25ffa0c2a969ee67ecbb252c841471c5ea9e2ce87e581c130ec800db482b51"
    sha256 cellar: :any_skip_relocation, catalina:      "192c19f127e900be34ca58bc3b7dec8b2fae412e53d2613396233f9e3fbb6123"
    sha256 cellar: :any_skip_relocation, mojave:        "5eedc0f7cdfa07a82325e09c5a3bc37e7250ad1fc87f48062c99a3a21f5964ac"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9448463d98056aa3b6049f00261fea896e2a16712407f8c10fdf61d9d82dd61b"
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
