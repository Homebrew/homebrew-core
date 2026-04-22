class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/24/91/b168a685ca6813ff9b467d76a7365a099aec16a1032b6edf39b0cd19f6c3/podman_compose-1.5.0.tar.gz"
  sha256 "5cc09362852711ce5d27648e41cb5fd058ea5a75acbcdec2f8d0b0c114a18e8e"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4075c4404daf3f94d39235b1a40462bf49f5e4c4911e1d7e59ded6759b39a97"
    sha256 cellar: :any,                 arm64_sequoia: "cd35948edbd452b89c207d31977627f5cac993d98a065a6da098b2ff9223e4fd"
    sha256 cellar: :any,                 arm64_sonoma:  "f5333d43282d786736756fc0faff6ef7ca5243e980e82e87f6b4c2ae0b143006"
    sha256 cellar: :any,                 sonoma:        "a20a968c26f5b4ebc8cac628503495bb11ab4762fb108ab744470a2bbb1f4649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d128d731587aaa9d77b308ff9f8396dcfaaa6d18b346acedc1d552d49af71461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1201faa12c2393e1254c9e122d6363177528e472f42c6c5a2056eb6d528de237"
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
