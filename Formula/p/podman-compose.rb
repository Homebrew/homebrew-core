class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/65/a8/d77d2eaa85414d013047584d3aa10fac47edb328f5180ca54a13543af03a/podman-compose-1.0.6.tar.gz"
  sha256 "2db235049fca50a5a4ffd511a917808c960dacb8defd5481dd8b36a77d4da2e5"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "93607b4de1bfa1b88c180c191a05eecb492eb97792855ef242a081017cdcbd88"
    sha256 cellar: :any,                 arm64_ventura:  "098a497efe77576d9ff553b14e7a5778337a33c6c938e10b88b9a168465a598d"
    sha256 cellar: :any,                 arm64_monterey: "91ff7145ee1db5f55d07b191c23d2f026eeeb35675bed0c2239fe8c8913c5f2d"
    sha256 cellar: :any,                 sonoma:         "4654dd7649f827bfec38c0f731564d1c8d09da13fdb4968abe77918c886259e5"
    sha256 cellar: :any,                 ventura:        "bd48d44af43746240d247a9548dc0593d268679b0eedd52c07c468ab065e5ad6"
    sha256 cellar: :any,                 monterey:       "0b837faadf3b412fc32162291b65ad422711c995d52d45281ee53f370acac161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5736ffb8cf39667421c7cd2a799dfb2f3277dc6fd7e417a1835117603100a30"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.12"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
