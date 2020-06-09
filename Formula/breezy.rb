class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/bf/52/2639c0653b0e64e49a6cae3a6b6f115e277ccbae47779af798fd903be6cb/breezy-3.1.0.tar.gz"
  sha256 "1eff207403f48898fa3b3ffa7a4275197c6c58fec105ef267caf1f5fd5a6c7be"

  bottle do
    cellar :any
    sha256 "db4650b8d106f2b8f5f09d5cedb950e6c6956c32169d59e5132523cdde59b848" => :catalina
    sha256 "10855340b0adf9467386e45466e039801d5a25561894e6e42d1e83ba230d40fc" => :mojave
    sha256 "bb807fed61ea5ec609bd3e36644f35b618b190e49f728906231b83b1a0d86aa2" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b4/19/53433f37a31543364c8676f30b291d128cdf4cd5b31b755b7890f8e89ac8/certifi-2020.4.5.2.tar.gz"
    sha256 "5ad7e9a056d25ffa5082862e36f119f7f7cec6457fa07ee2f8c339814b80c9b1"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/16/8e/b43e8e612cfe0e03410cd23da18094cbb78296fd56a8275f8213ac9a7699/dulwich-0.20.2.tar.gz"
    sha256 "273fa401e11c215ed81a4a0c8474ed06aeae31900974fdd4a87af5df0e458115"
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
