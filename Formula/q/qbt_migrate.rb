class QbtMigrate < Formula
  include Language::Python::Virtualenv

  desc "Migrate qBittorrent downloads"
  homepage "https://github.com/jslay88/qbt_migrate"
  url "https://files.pythonhosted.org/packages/80/bd/8f0a3474f117096db1d9c4570ec660ea29db38f1726ec1c8b809456c2d0d/qbt_migrate-2.3.2.tar.gz"
  sha256 "a9a5102bf6ca17893012dc604db0d71436cbd120b972a878587fba47edeb0b10"
  license "MIT"

  depends_on "mkbrr" => :test
  depends_on "python@3.14"

  resource "bencode-py" do
    url "https://files.pythonhosted.org/packages/e8/6f/1fc1f714edc73a9a42af816da2bda82bbcadf1d7f6e6cae854e7087f579b/bencode.py-4.0.0.tar.gz"
    sha256 "2a24ccda1725a51a650893d0b63260138359eaa299bb6e7a09961350a2a6e05c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Cannot be tested any further because the actual functionality requires .fastresume
    # files from qBittorrent, which we cannot create here.
    assert_equal version, shell_output("#{bin}/qbt_migrate --version 2>&1").chomp
  end
end
