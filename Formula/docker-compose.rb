class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.26.0.tar.gz"
  sha256 "481cd772e3d0592bfc3f076f4a5af11a7c00eda45e2cb61208b1c66b1650d25b"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "a44fef29184213b0c514a619d08783eb98d0843c64271db970df2cecdd670962" => :catalina
    sha256 "41389cc6707d1ac99ed3d226951ea165d773c0ebc3c5081a24c54187a9c8c192" => :mojave
    sha256 "4ef95bb3cf0b36c006e5074f82ad74a63e70f3f400133b1a25f3772bc70f79d7" => :high_sierra
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
