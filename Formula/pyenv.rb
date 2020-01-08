class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.16.tar.gz"
  sha256 "a4cdda5902a2507518db460c375fcec5eee3ce7e3527a3e623bfb0b3c7543ccb"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "1da51fb67d5aac04bda57820d4bf9cc4454a6674a99c98fec4e42c8a32fa8dac" => :catalina
    sha256 "e16a7e18f0c439d1e8281cc512296d2cf289e538a2364c1b83e4384bf53c2a43" => :mojave
    sha256 "97ce8482cadd990833d98bee07dbb9ebd71bdd62b38b24248a10942e50519797" => :high_sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
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
