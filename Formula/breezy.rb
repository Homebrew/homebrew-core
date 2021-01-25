class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/bf/52/2639c0653b0e64e49a6cae3a6b6f115e277ccbae47779af798fd903be6cb/breezy-3.1.0.tar.gz"
  sha256 "1eff207403f48898fa3b3ffa7a4275197c6c58fec105ef267caf1f5fd5a6c7be"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "573375e163fbfa507e6fbd20e52559b30ca1c97ba8ef2f45eecc3b4ae8b4bb0d" => :big_sur
    sha256 "3b56b4e6ac7ad2470781467392aa0018754fc03e4f84bfee2d93a00e64c33afe" => :arm64_big_sur
    sha256 "1a5f132188241df2ada428e97f0dc09712b9bbf803dc4ea974e07b38f9ddc247" => :catalina
    sha256 "ef7f756a7ff7beb049bde8f7a9e41eba5cc2f331c7efdb9d8b5d8ff419836384" => :mojave
    sha256 "d818d00021c542d21438b4014f5e9461378144de16d2525c52868d5d2998922c" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/b3/34/adcd6646c5ed59a1206216d4a418121be57df3406f7a46570112db57ba6c/dulwich-0.20.5.tar.gz"
    sha256 "98484ede022da663c96b54bc8dcdb4407072cb50efd5d20d58ca4e7779931305"
  end

  resource "fastimport" do
    url "https://files.pythonhosted.org/packages/aa/65/47a579aae80fbd8b89cfbdffcde8dff68d57e3148b99da6a326673021455/fastimport-0.9.8.tar.gz"
    sha256 "b2f2e8eb97000256e1aab83d2a0a053fc7b93c3aa4f7e9b971a5703dfc5963b9"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/73/b7/31e0cfe41c63ceb9b745a998eeaf60b350c5265704c54d4f5d7960364107/patiencediff-0.2.0.tar.gz"
    sha256 "d828c8dca0db860b26d441097e866a75f3ded8ea45244d3ba5f691a62928537a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
