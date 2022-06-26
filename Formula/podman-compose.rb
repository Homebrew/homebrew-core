class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/c7/aa/0997e5e387822e80fb19627b2d4378db065a603c4d339ae28440a8104846/podman-compose-1.0.3.tar.gz"
  sha256 "9c9fe8249136e45257662272ade33760613e2d9ca6153269e1e970400ea14675"
  license "GPL-2.0-only"

  # Depends on the `podman` command, which the podman.rb formula does not
  # currently install on Linux.
  depends_on :macos
  depends_on "podman"
  depends_on "python@3.9"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/02/ee/43e1c862a3e7259a1f264958eaea144f0a2fac9f175c1659c674c34ea506/python-dotenv-0.20.0.tar.gz"
    sha256 "b7e3b04a59693c42c36f9ab1cc2acc46fa5df8c78e178fc33a8d4cd05c8d498f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
    assert_match "Cannot connect to Podman", shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    assert_match "Cannot connect to Podman", shell_output("#{bin}/podman-compose down 2>&1")
  end
end
