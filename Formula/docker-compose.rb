class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://files.pythonhosted.org/packages/62/63/a0adc442f57aca3b6d8606b93dc43b0ec47bfb7e363157c88e27e5b2ccc2/docker-compose-1.27.0.tar.gz"
  sha256 "42553bb8b991b66ced557725714197f13a46d5626f8ab25d244000fbf4ee2d25"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "bc1ad5db046542ffd71a82f925bf9528508a11a7de0a48926283523513b218a5" => :catalina
    sha256 "7cd3ecbe6c03b9425674bac87430e2a988bad2e4335f485d71679348ff7226c5" => :mojave
    sha256 "f4883d177fb8cbea9bd9c289a04b774c02d201cf394156f09207cdcf3ad9d2da" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
