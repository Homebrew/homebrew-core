class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.13.tar.gz"
  sha256 "ebf9899f70cb04a6a6bf9835c37d9d7e4ed7dadb22dd8123b19d6d790a13fffe"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "328765d7bfe1c36a25274b5a985b3e64300f06d13495e248275b92e4502d6da3" => :mojave
    sha256 "f0bc9bf9a8a36bec4804ad39c8eb000cddb0df14c99c4548bd1e1d6647e71091" => :high_sierra
    sha256 "64ef6e621e9592d48f7a56b9559b3f69231017a91d3b834f1f1daa263712cbd1" => :sierra
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
