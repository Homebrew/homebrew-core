class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.9.tar.gz"
  sha256 "6e76b91b90abc2e1c18b590856e9563d9c8c3c24d5536b9f133a3ca29bc9ae35"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "ebcf25bddd04fb19930274dd585433ba809488e316d03b99e2f66e0c42fab6d9" => :mojave
    sha256 "7ab9ac15d27a89892e523e22ae165e229d3c593b898f070c6977e0f924519c4c" => :high_sierra
    sha256 "3a255442b2ca904cedff913d8cdf0eb14fe00d95123d6af8d6257d2a9335cf7d" => :sierra
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
