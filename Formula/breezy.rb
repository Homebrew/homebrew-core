class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org" temporary? 503
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/e4/56/bc9f139cfb5eaeb9f0e155bbe2071f97167994b7cbc4c2cced04c48e4a80/breezy-3.2.2.tar.gz"
  sha256 "187a6e45208dd05d81750736720c83710cf48094f547ec4081c571259559a4d5"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4efa2014683c95cb84b1936f18d2781ea93c790c7a571551411ca2f523c3aa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef29a6820cadc6c5f32229f1c3ca057b9f99853267ae6617c168b5cd7528d303"
    sha256 cellar: :any_skip_relocation, monterey:       "413b94764ce73c52587dfff3374ca4f46cbe4e6b72bbe9f37e872d669235ea84"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f4f42c1ef5c277eea920f6f54eff4365958b138805525e1fe397b427ba665fd"
    sha256 cellar: :any_skip_relocation, catalina:       "0d380ba60255d48e882758b26782899b0b1b3c440b0ea63d4c0922b03cbe7295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b1aef85237286c781dbb36c1e88ac822862001368b6c6b48f46c429292eb26"
  end

  depends_on "gettext" => :build
  depends_on "libcython" => :build
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
