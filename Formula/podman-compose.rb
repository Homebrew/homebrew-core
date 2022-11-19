class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/c7/aa/0997e5e387822e80fb19627b2d4378db065a603c4d339ae28440a8104846/podman-compose-1.0.3.tar.gz"
  sha256 "9c9fe8249136e45257662272ade33760613e2d9ca6153269e1e970400ea14675"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, monterey:       "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, catalina:       "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be33e397146ed2ab7795786284cbeb1fda7fe45ca235925c075bd69f19c3f299"
  end

  depends_on "podman"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/87/8d/ab7352188f605e3f663f34692b2ed7457da5985857e9e4c2335cd12fb3c9/python-dotenv-0.21.0.tar.gz"
    sha256 "b77d08274639e3d34145dfa6c7008e66df0f04b7be7a75fd0d5292c191d79045"
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
