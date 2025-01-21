class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/a8/e7/0d23c675128a53bc220c296e6abdcbda872dd1fef48d4513f351f4031d24/podman_compose-1.3.0.tar.gz"
  sha256 "e65a70e8fa26bd195d2017ac5893149b40c0df5a0c20d480a338c4f60218b1fa"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9a57d22695b12c676270eac773014f29b71915dc86c54b2fdb7fa04ea1a784e"
    sha256 cellar: :any,                 arm64_sonoma:  "f04f6a13dc14bce1bd009a15b2a1a5c87b38b2d76040c1ed5eba2a8ce40bc8ff"
    sha256 cellar: :any,                 arm64_ventura: "096c98f916a1fb28cc5fa2bd80c26a05afdb9a4bab6dfafeb8060957c7180281"
    sha256 cellar: :any,                 sonoma:        "3da16d68c06a2cd8020cbd587e794b5310ae8c6e8c4a7583e0a08d68d1d8287a"
    sha256 cellar: :any,                 ventura:       "49ebdb098d3af1a52d20aa9fbf0e9c4cfe85e2936a5e95b35a29696142bf2305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5b61059e28b5bcfb7b04605cb01dcb8e6441025baeccfa88bb7a69234ce40b"
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
