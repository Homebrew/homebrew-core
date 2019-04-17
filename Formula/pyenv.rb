class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.11.tar.gz"
  sha256 "3756c0e386c3a6a6b36f2f8d6cc55441cc3aae1190f74c01f15d7dcdc0cae6fa"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "54876153bcbe6bfdecd0b232ab112571120c84ae8c11e610c07775026e403818" => :mojave
    sha256 "d12b5973fd18eff3909998ec8c757e2f2074984df58939c528dc3467b703671a" => :high_sierra
    sha256 "9c333a6b41589f4fe0a6e689043e983eb21f89500182040eaa99cf6efc230ecb" => :sierra
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

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
