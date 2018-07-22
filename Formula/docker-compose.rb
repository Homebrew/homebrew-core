class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.22.0.tar.gz"
  sha256 "d28a2e96976dae306f480f656e4487a0334a5f95c456408f4bbe4acc5760ffa0"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "e3297ba8e7066a3fb48c195b4d064d767659f5d73bf0fbc9b17c536a14b99969" => :high_sierra
    sha256 "33b04317090c4c35b9178e866e99816da7df6cf06d1d73a3aafda14c2ec5522a" => :sierra
    sha256 "5384c36aae1861722900b82aedf8440d9f2069a242573c22c8dc5faa9443646b" => :el_capitan
  end

  depends_on "python@2"
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
