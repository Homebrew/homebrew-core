class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/bd/67/0f8cf5ef346a22ce73dfdd0e60cf81342329b71a7fc118128929f0c07b62/podman_compose-1.2.0.tar.gz"
  sha256 "e47665546598a48d83d30ca2709a679412824bbe84b93f61779bc863e1a6f060"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "10dde7d6207bd40143e7e2c57ea1c46dab8599d541ed7fb04e3a8c673d96936a"
    sha256 cellar: :any,                 arm64_ventura: "e795544ff6e7ec30ffe28e8f27f8533f3e08d3ee587b540d5dcd95ea6a785eaa"
    sha256 cellar: :any,                 sonoma:        "030a9bd00b8ba60f8c91450d2d138f6a022503e178ac48993ddf6b9136dce7e4"
    sha256 cellar: :any,                 ventura:       "77bc7b087a72453dfde46e5e22988403fe472bd06691b0a89e7f723d4a898092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9adcf18992eccc71f72b3652959d6ac65dd9710dd4bf823d3e1334648a5f9042"
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
    ENV["COMPOSE_PROJECT_NAME"] = "brewtest"

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

    assert_match "podman ps --filter label=io.podman.compose.project=brewtest",
      shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    # If it's trying to connect to Podman, we know it at least found the
    # compose.yml file and parsed/validated the contents
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1")
  end
end
