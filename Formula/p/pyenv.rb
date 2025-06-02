class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "aa664ab4076f0f27b767e7bbe9b828222cf3272a6c1d35a87b6717daac0bf624"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70678f1e3508a5cc2f2e82a16afbdfd6dc9fbae948c21a7934b461d72ab3e214"
    sha256 cellar: :any,                 arm64_sonoma:  "3fdba3496d3cc6fec59a93c540ca48d684d4714de0af7969e91eec4b5326e679"
    sha256 cellar: :any,                 arm64_ventura: "187d4b9ce41f546482d104b82bc6dba858056c9695ebfd1e896338dc3bb0efcf"
    sha256 cellar: :any,                 sonoma:        "b92b72d8e5bd7066f65c700b8afb800066907e48d6308b9ac8fc410f77fc2010"
    sha256 cellar: :any,                 ventura:       "532392acbd1850c7b9dfcae3cf09e110d7ec0891fe7f76e52f45c79d4f98b4ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899a71a7ba3904476bbcb1eff10fd416495f786c18277c73bdeccc46b394ed58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c619310123499404cc9126bddc6912cad33d1bc932527842624d01fbd5fe13b2"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
