class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.13.tar.gz"
  sha256 "ebf9899f70cb04a6a6bf9835c37d9d7e4ed7dadb22dd8123b19d6d790a13fffe"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "f3ea4fa71c2ff552a0e4922c9ab77ac236dbf6a6789006d2c49d0aa248af734a" => :mojave
    sha256 "7d5808b4d49d6e6dfab88a215f5f51a7b2fda3a84a604025240707470baa2e53" => :high_sierra
    sha256 "959f0d8ccdd3bff759a0a7bb1f9201c8b06e437508271f14f418f83194f939fe" => :sierra
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
