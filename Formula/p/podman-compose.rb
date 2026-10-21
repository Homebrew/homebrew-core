class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/1f/80/a6ada19562b12ed466dac5c3e02aef5ed7c8d0881864d80e0d94d0dc71f5/podman_compose-1.6.0.tar.gz"
  sha256 "c83fd9bcbaa635100d581ce52a7a4b712ee0d457481232aff392efe3ebc5a217"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c7050064a5a62abd626e29ddc2fe819ec3898bea98d8013fc0fe229098fc18cd"
    sha256 cellar: :any, arm64_tahoe:       "7bc87cd8a3b94b493ec7e2d7695e69c120dc97ed5666cc46543e0ae8a466b0d0"
    sha256 cellar: :any, arm64_sequoia:     "33cd6144da68f8a941af2735eb2da5107a43b89dda22a925a084e689e2ae9ae3"
    sha256 cellar: :any, arm64_linux:       "b40b76b8f7de6e33f9bc6efc866c49ff0c086732fb585b1f036d7bac36855dc5"
    sha256 cellar: :any, x86_64_linux:      "19458ab1e88b6217b903259abea485e67c70b46500408494031283f18083e200"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.15"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
    expected = if OS.linux?
      /Error: cannot re-exec process|Error: command required for rootless mode/
    else
      "Cannot connect to Podman"
    end
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1", 1)
  end
end
