class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/bd/67/0f8cf5ef346a22ce73dfdd0e60cf81342329b71a7fc118128929f0c07b62/podman_compose-1.2.0.tar.gz"
  sha256 "e47665546598a48d83d30ca2709a679412824bbe84b93f61779bc863e1a6f060"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2b0450478fc05e29053140b74baf734040c0334cbea9f3738b8ae4ef87d565de"
    sha256 cellar: :any,                 arm64_sonoma:  "2f5ecb07c5a56e45ba262eddb097708f021b3b8b2fc26b34b5206656be7bab7f"
    sha256 cellar: :any,                 arm64_ventura: "5f7fa2fb42952693a1c28b0380b2d6ceaae323b6ed7c2829a7bc3a0281dd98b9"
    sha256 cellar: :any,                 sonoma:        "a4908c77b78817b69d253a671a60c80f974a6c7a5f69af54298b76ff7de5726d"
    sha256 cellar: :any,                 ventura:       "22fc99aa7a5c268f4adf31897f54e36a207ab73b236300816cd5ccba6d703381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56271a49c2485596fd9787d20bb1d046783c7afb77909a76ce516004836fe838"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.13"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
