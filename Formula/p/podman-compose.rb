class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/24/91/b168a685ca6813ff9b467d76a7365a099aec16a1032b6edf39b0cd19f6c3/podman_compose-1.5.0.tar.gz"
  sha256 "5cc09362852711ce5d27648e41cb5fd058ea5a75acbcdec2f8d0b0c114a18e8e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc95b8db01360328a27dbfe521331582424ff9e2558861ffb628fc991bfa0960"
    sha256 cellar: :any,                 arm64_sonoma:  "106210fb886ed1a3ae18f353f5bb3b1d2406b84c6073f50309b45b08a10eef97"
    sha256 cellar: :any,                 arm64_ventura: "339634a4030bdfa570be9810d7450ebc040c8602a8283b590a79118beb4b1b1b"
    sha256 cellar: :any,                 sonoma:        "5b7cf2ab78f0a7c9ca04d7dd874e082ba2c879a26f2c85b84625b2328d94b90a"
    sha256 cellar: :any,                 ventura:       "6db0a62d4d6abb3a7760c430194e48d6fc588ea1da8ebf56822bfaafa2f80c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4962aad4d0ab9fca270ea362f25f506e8d002f02c75b8888bc1eb0e1e0ac3d4"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.13"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
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
