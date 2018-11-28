class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.23.2.tar.gz"
  sha256 "18ff12f80e21011e76e04d2579745224316e232a5ca94c79a2865dac5c66eef6"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "e0ff1f3b92d2a5988ad5b189845eed2365488858caad420a4987870975e9d157" => :mojave
    sha256 "67412075e97748cefff34332166f5c14f201ae7306f93450b4b3a5ae414d4cb7" => :high_sierra
    sha256 "6475cd7be1a7b4f3c2cd622c9e1c65a146e2327b926a2f57a961f4c9264394ae" => :sierra
  end

  depends_on "libyaml"
  depends_on "python"

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
