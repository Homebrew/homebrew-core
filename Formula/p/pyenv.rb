class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.31.tar.gz"
  sha256 "cc9bbd814e5da1c461623ce151d3404591f4b0245df24cb5cebf16a7a300f9a1"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78bd2f999d31e4edcef7226290fd8d8877a7be53e5b222f703eedcca87655444"
    sha256 cellar: :any,                 arm64_sequoia: "9dc707ef6a2c335b25fae5c2eca725751a5d04143b461e7b937b897cf56b2710"
    sha256 cellar: :any,                 arm64_sonoma:  "f51d67ffaa9cb7b7b8703ff5c8773034b2f4823a6cf7ee29c1d6205eca224b6f"
    sha256 cellar: :any,                 tahoe:         "f0ac250348e1b23f89247c100c59f4b01e9c2b09826adb7e382f46135a89817d"
    sha256 cellar: :any,                 sequoia:       "1d7aa864aaeb70ff33a4aa4bc5b1b0803d834ddd70626f59130b6a4020844a88"
    sha256 cellar: :any,                 sonoma:        "a1cae9994cd2c3ff2126b9b3908d3cfd151db017f6d50df310d8ad37f209a5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157aecc772de5f519a6bfd3502d007b1155af30b67437538e568a999b3580f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd24ced62062bddab4f66a18a5fa5cda45b16d6d1432f5962ad19300afd2b0a8"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
