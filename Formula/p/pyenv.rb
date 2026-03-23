class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.26.tar.gz"
  sha256 "3ba6b803f3dc4ea0a794abc2d585a3a917dd031986d100615a1477a3be364ab1"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fbdbf840a5b35cd69dc4907eadf972873d3f87d543e7d41b6e9dc9e69a1d001"
    sha256 cellar: :any,                 arm64_sequoia: "479cee567f289bc5cd93d23531d7e07f043cfa57c37b479d8a5c365880ea6f7d"
    sha256 cellar: :any,                 arm64_sonoma:  "79dd10317facef2c002a58a3a3f5c1640abcbbfea2eeeceb3f9dae4eeb29c699"
    sha256 cellar: :any,                 tahoe:         "756c26ebcd10d449201f4c82c62eeff6727c1e8dabef5cca1798da1cf2433d8f"
    sha256 cellar: :any,                 sequoia:       "a5d0892e6249dc5c97e6c37b6b311c5cd28f6a2e9f2bec189c7dc1fd759fc6dc"
    sha256 cellar: :any,                 sonoma:        "5b410facec0e581468b3419a8b4e66cdd6973c1edcdcc5bbab91290a677482bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a71e381a82f94249083016b98bc457f103a67d4fc91877c789d6f7178b00bce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b1147c892876f52076ab3fc204f9787d67b5875d31433eda078622ea7f515b"
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
