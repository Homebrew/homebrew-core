class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/24/91/b168a685ca6813ff9b467d76a7365a099aec16a1032b6edf39b0cd19f6c3/podman_compose-1.5.0.tar.gz"
  sha256 "5cc09362852711ce5d27648e41cb5fd058ea5a75acbcdec2f8d0b0c114a18e8e"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6d9765042f7c657a9988eba299ea87413ebc88b51dd301bf0824eb2f42cb5fbf"
    sha256 cellar: :any,                 arm64_sequoia: "64ec31c99c8f3eef79b7bff65d15f3aa9fee7c3d2cf10db798934655650b2eb7"
    sha256 cellar: :any,                 arm64_sonoma:  "b090788eeecfb9762576fc0579cca1e237dbe78fe81d1bf83ec5027ce654550c"
    sha256 cellar: :any,                 sonoma:        "0c3fef86a51ea1e01f3b292042a21721adbb26b2d3220be6a4cf3d4a64ee1b9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca19cda30ccd74d9837a3fadcc36b637d85a38fa42ba765f39ebaaabda87f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2225e553f4109c8f560ede2cb744456f8c53e625ad1f168cc66f9d4cad789835"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.14"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
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
