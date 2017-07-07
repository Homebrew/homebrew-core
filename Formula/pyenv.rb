class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.1.2.tar.gz"
  sha256 "6274f50f67561ea054d8c7a9c332001db28709a94fd0bd2586f8b441c4856e5c"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "021de942f227288e4d22d283fecf254f3ab5a4e78c1211d1bbd3b160763e663d" => :sierra
    sha256 "f99ffcf69af35925dd09c232a06c0654a94178a97ea77dfb4cf3f56157ff1d79" => :el_capitan
    sha256 "9218c60c41ea010007cdedb23e10a3eb99db958f8d7b67d509de89dd52567f67" => :yosemite
  end

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
