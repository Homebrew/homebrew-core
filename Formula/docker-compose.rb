class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.26.2.tar.gz"
  sha256 "7c33f2a949b8ef15f36a03574a05c55246615db23134fd1377324681bbbca095"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "2fad16dc653ab154af4ab9107bd8222df6370b3fe5ffa64ae31a5b6abb47cefa" => :catalina
    sha256 "bddf16f5594ee5172d3a1afe22ef4d372fb4dc0d7f3fc8112bcaff041015cbec" => :mojave
    sha256 "5a69754a7f778e02ea6b7a4ca6ee0fa97682f2b019e80e43833faba4654bfd13" => :high_sierra
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
