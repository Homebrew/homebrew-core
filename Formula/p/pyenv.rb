class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.27.tar.gz"
  sha256 "52c0934540d2fc7e5da03f4de92170c6a33d03b5f00cd191e4dd281fe2d0ea8b"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4285c5f570424b50b4b1bb8660737c4edc4e2e393b6e6ed808b8faa1f9adbd16"
    sha256 cellar: :any,                 arm64_sequoia: "8ba74da7479b83b6c0ed691eadacfb323add2e73dfdab7852f9081a92b739740"
    sha256 cellar: :any,                 arm64_sonoma:  "2000e4f4ae830013fccab645d3b31e2bb9350c7189b1abda63b3bc4c15b57b7f"
    sha256 cellar: :any,                 tahoe:         "04770105248da8ac2b5cbb8bedc3f464e839a4a838c34d936e73be314250d292"
    sha256 cellar: :any,                 sequoia:       "838bc9c4ee3439f72e41c230ffd10b55524e6ab282e2c14e4de0d2e07236c778"
    sha256 cellar: :any,                 sonoma:        "825861d25a642aed651036e2c77cb5b912d50840c907c24ace32ec4ab9da4b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104426a1662e1947a66ca4342d3de95c3b5882ae7fc66c209ce0f7b185233937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72684fd143faff092c6b839f26fec47bcc26b0c4ef7e568b8512143680297c38"
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
