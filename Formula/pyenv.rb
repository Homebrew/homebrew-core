class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.18.tar.gz"
  sha256 "cc147f020178bb2f1ce0a8b9acb0bdf73979d967ce7d7415e22746e84e0eec7a"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "bd9f719f153e9574dcc65dc7fea28a3816557bd46b0ff90ad8de43f3f8dc72c4" => :catalina
    sha256 "05f0414ec85ad0eb46a4046d9bee6da318b2b68fd9b64b11875cb2457ac808ec" => :mojave
    sha256 "e789844a5fc1efd1e53a60d87032b279823933cb1a79839fb67dd34a9fd7e96a" => :high_sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "python@3.8"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-versions", "system pyenv-which python", "system pyenv-which python3"

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
    # python@3.8 is keg only. Pyenv needs Python 3 in the path
    # to work, so provide our version. Users can later on choose
    # which python they want to use by modifying .pyenv/version
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
