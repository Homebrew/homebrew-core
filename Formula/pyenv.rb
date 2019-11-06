class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.15.tar.gz"
  sha256 "115c30021410a3d3764b5413fdfc06db1efdcef88fb3b65867bea1765eea3505"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "b3a2c8756d697a74b665aa9e3a2e41abc991f592640492dec99afe1eef0878c2" => :catalina
    sha256 "ab7e341286ec746f5f286284ad18703be8197810de374674297ec860c6c4dc00" => :mojave
    sha256 "4a65548a46397a568717557cd7b012feeb4660391e8b8dcfa5d503cfb448f6ca" => :high_sierra
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
