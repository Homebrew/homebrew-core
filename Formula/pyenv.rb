class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.5.tar.gz"
  sha256 "6b41f2aaa81d956339a2c20193d10a6c2bcd0e47ac2f382a6c525058803aefa7"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "a51c6ad8b274e8e7c3b79fdee4a0562b93510a839b57dfc089c42393fafd58e9" => :high_sierra
    sha256 "8211a2efe0eb15bdad00f214420cf7721c030bd41ab94933b718b334f6e28724" => :sierra
    sha256 "1144a407abd7284be0352d6f07020b0d21e02d640a54b0a8e7da9216629d63f0" => :el_capitan
  end

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended
  depends_on "readline" => :recommended

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
