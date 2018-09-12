class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.22.0.tar.gz"
  sha256 "d28a2e96976dae306f480f656e4487a0334a5f95c456408f4bbe4acc5760ffa0"
  revision 1
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "6f4fd0b89872112313590bbfdbda5a9724a09e5ab68f72a63e002817661c8433" => :mojave
    sha256 "c9cb00b759ff10533bda01529bcf94167e92f3ea7adc182f0a3de42716ea87b1" => :high_sierra
    sha256 "95141cd35a49a0c2ede5606c0a2cc37d53d47f80559467135d2b22bab7732d5f" => :sierra
    sha256 "a626ce2379b1b9f635eb2917498452f0d50c4944ba9c9636387be121370e8f5f" => :el_capitan
  end

  depends_on "python@2"
  depends_on "libyaml"

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
