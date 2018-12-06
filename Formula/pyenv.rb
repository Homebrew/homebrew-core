class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.8.tar.gz"
  sha256 "79c0ba0fa6fce3aa71e71d666d8082badbb52bc88dc3ed05b3c4b1ceeba54991"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "dea10b5b953c6772d5bc7358e0afba94ed458aeab405211ba47a7dc7e3887989" => :mojave
    sha256 "9f206fc149947ee70a2b047e8997b6bf0e523bdef0ef5114a3fc757da4352b61" => :high_sierra
    sha256 "a950cc23612877468d69dc8c896eec55fd52bd8e8bbfa9c5c03d26bd5322b106" => :sierra
  end

  depends_on "autoconf"
  depends_on "openssl"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    bash_completion.install "#{prefix}/completions/pyenv.bash"
    zsh_completion.install "#{prefix}/completions/pyenv.zsh"
    fish_completion.install "#{prefix}/completions/pyenv.fish"
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
