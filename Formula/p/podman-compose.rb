class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/1f/80/a6ada19562b12ed466dac5c3e02aef5ed7c8d0881864d80e0d94d0dc71f5/podman_compose-1.6.0.tar.gz"
  sha256 "c83fd9bcbaa635100d581ce52a7a4b712ee0d457481232aff392efe3ebc5a217"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97704e9501523ee9e8a58a863fbee60ac0a28d92dafda898c144787e70272d61"
    sha256 cellar: :any, arm64_sequoia: "cb8a6a4c0109b92c3bb4380c6b25af0d013b2dc91806a23e28ddd28ab6a3558c"
    sha256 cellar: :any, arm64_sonoma:  "20b45f872570323c8c7adb78792911df1f440d06022b8d62c3c2760b17766240"
    sha256 cellar: :any, sonoma:        "bd14f22447ff9ebb5fbf2837a13e7cfc65c0b1dbaa6923df7a5b0b253192453b"
    sha256 cellar: :any, arm64_linux:   "581329e037c0965d3e573193524d879bbbf53f1b10e2d03d9bb3b46fe6231701"
    sha256 cellar: :any, x86_64_linux:  "dc6f0c240db6ec3a0e3bf878c1d955c997b18e4b89c1ccf21edf8a8e8f12c52a"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.14"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
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
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1", 1)
  end
end
