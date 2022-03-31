class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org" temporary? 503
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/e4/56/bc9f139cfb5eaeb9f0e155bbe2071f97167994b7cbc4c2cced04c48e4a80/breezy-3.2.2.tar.gz"
  sha256 "187a6e45208dd05d81750736720c83710cf48094f547ec4081c571259559a4d5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8a5763087458c87de1a7bc1bae7d52a9ddd4241a082070c087236ec9be6519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a116bcb078c8dec25d71d95d86ae296130f704ebc9c98e9407d7e1e5f317db3"
    sha256 cellar: :any_skip_relocation, monterey:       "461e03ba2625e54d5da2c08e17939e4ca501506edbcf5d0a6216950e5896c76f"
    sha256 cellar: :any_skip_relocation, big_sur:        "706c12693a87e7669f3bf4855523afe1ae7f27e3f61fe7675e3867ce943ccc1d"
    sha256 cellar: :any_skip_relocation, catalina:       "6b0121c56e6d0025d1410157b04b3219cacb6a6d2a6a95f611f8b271ded0656e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c914a0b4b10bf2eed4c6f6cfa8a218b9f0a7204ce41652cea707b3dd446b5905"
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/28/0d/e89036c08fd49722ca7091cc574c0f133d667a7ec37bbdff763b15ec0913/dulwich-0.20.35.tar.gz"
    sha256 "953f6301a9df8a091fa88d55eed394a88bf9988cde8be341775354910918c196"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/27/8c/b98694c74535f984f220c3762842e7aa17c60d5c12103093e0ce0da8edb0/fastbencode-0.0.7.tar.gz"
    sha256 "b6bc9abe542d0663793529576f49ba8891508554f85d09b5d6d5ed7af7e0c6e4"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/90/ca/13cdabb3c491a0ccd7d580419b96abce3d227d4a6ba674364e6b19d4d67e/patiencediff-0.2.2.tar.gz"
    sha256 "456d9fc47fe43f9aea863059ea2c6df5b997285590e4b7f9ee8fbb6c3419b5a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
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
