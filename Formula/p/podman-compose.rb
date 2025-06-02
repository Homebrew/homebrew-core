class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/14/85/7f9ea7574a35226cb20022f5f206380d61cec9014be86df3cac0aa6a8899/podman_compose-1.4.0.tar.gz"
  sha256 "c2d63410ef56af481d62c7264cf0653e1d0fefefdcee89c858a916f0f2e5f51f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "741d1edae85226304ec701a1cf3655fd44b88530d9a8fd30512068a1647210e2"
    sha256 cellar: :any,                 arm64_sonoma:  "117a908039d78c429cb489ba9e785d23af0ddbba23a271b60571a5a3b560f3ef"
    sha256 cellar: :any,                 arm64_ventura: "213f304df9e41f5ccf8d730a29d00f8f36f11f626122f4bc7dc42b25bace43d3"
    sha256 cellar: :any,                 sonoma:        "217da75f6dc36f60662e70b86a2b51be3a21777f0efc95fdcb7b1bfe9ebc47cd"
    sha256 cellar: :any,                 ventura:       "e73aa26f2d193be53e6e3685e36d2be4671796067b18793b0ad147f82b746772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f73b6123db9131b2045faad026def2e076b36138d9626a94f1cc7e9a6fbcc3"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.13"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/88/2c/7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5baf/python_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
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

    (testpath/"compose.yml").write <<~YAML
      version: "3"
      services:
        test:
          image: nginx:1.22
          ports:
            - #{port}:80
          environment:
            - NGINX_PORT=80
    YAML

    assert_match "podman ps --filter label=io.podman.compose.project=brewtest",
      shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    # If it's trying to connect to Podman, we know it at least found the
    # compose.yml file and parsed/validated the contents
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1", 1)
  end
end
