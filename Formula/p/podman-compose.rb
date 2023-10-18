class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/65/a8/d77d2eaa85414d013047584d3aa10fac47edb328f5180ca54a13543af03a/podman-compose-1.0.6.tar.gz"
  sha256 "2db235049fca50a5a4ffd511a917808c960dacb8defd5481dd8b36a77d4da2e5"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "becb8466afbb5d6b9b61079da397d98e0c592fc4471e5bceadb8a88364a5efbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3204f96b8e98a2fcb20dcafe036a3b7e25b115f4f81b27f65dac5d33716c0f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da701c43e938f94868e201dd00259da79ae4e7c697b7dbd0098c7da9ddb7e56f"
    sha256 cellar: :any_skip_relocation, sonoma:         "519db088b6e269efd89cb223b2f4233082454e4d41b2db5f0b969a8bfdb4c68e"
    sha256 cellar: :any_skip_relocation, ventura:        "d92642fb09e8231385c116a633affab24dbd5ed73e10cf17e7467bffb4ce739c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a2faa01e0c24959aedbb50f0492d6a9334a0e3444c33bb44a363edebe4e6e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236c6bed04d63d4585c7cea61f82cf63a2a1aac14c4fc9eb1ff736f405ba30cb"
  end

  depends_on "podman"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port

    (testpath/"compose.yml").write <<~EOS
      version: "3"
      services:
        test:
          image: nginx:1.22
          ports:
            - #{port}:80
          environment:
            - NGINX_PORT=80
    EOS

    # If it's trying to connect to Podman, we know it at least found the
    # compose.yml file and parsed/validated the contents
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1")
  end
end
