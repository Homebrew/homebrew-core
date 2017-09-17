class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.16.1.tar.gz"
  sha256 "c1a0416f4fc1fb83471dd9151e4dfafb835741af05a503f2784627d5fc4bbf15"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "f56e744dde5160d466674f2eb5cc6f977cb8b1b9969d9bf316afb7a3a9a77759" => :high_sierra
    sha256 "4b30345a5ea6547271d3caf7a6f0dc506e2f1e98b553856c31166c47c5d69efe" => :sierra
    sha256 "0f8f3727e94dbe95d66c8af24e7cb5ee8759c4cac850aa894971252a7b43d264" => :el_capitan
    sha256 "3fee04a4547b45b981bcc1e65244f8043cd1e12170487729695d4a8fb8b26c5f" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec)
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
