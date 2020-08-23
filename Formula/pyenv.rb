class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.20.tar.gz"
  sha256 "5ecd10d3ec502ce9b7d8109fbe8cb2e4a8af8b73ce5c216b8e268452724a65f3"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "74e2f3a7cf6513948cbac05f3af8f3f2ae7df825dfc21a91759963afbb398420" => :catalina
    sha256 "ac4f0bdd6bba22dd590ce2b2e86ee51300c3bb708288bc26e6294e1035a38a03" => :mojave
    sha256 "608b5e27568abc7c326c0bb066cf6d188c829362dd0dff718a04a44e9082f82a" => :high_sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

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
