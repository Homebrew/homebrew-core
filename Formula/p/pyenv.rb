class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.23.tar.gz"
  sha256 "45faa914c1e4a4f5ce60a39a646f708565134ab967783574c449202313aa5ca2"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52596a97adc0a04495c49a00ffd6ddeca6a5251b8b839746b6af56ea8f1e72ad"
    sha256 cellar: :any,                 arm64_sequoia: "76eed73d262220e267ddbcdb9c2d75d260664a5050f4943998a4a3a0370b0ae6"
    sha256 cellar: :any,                 arm64_sonoma:  "4ffcbc4af3ac1eb7e755ae77a63bb998328f2a9c07d14afc584bf19eeed5dff7"
    sha256 cellar: :any,                 tahoe:         "63502346d2c6c2dae2c7401d4cd7dfc498a3d7260678219c5f515279ee278a34"
    sha256 cellar: :any,                 sequoia:       "85a62d42015f47dc3c1a730c3a3c26bdf308fc0aef0666e7a1791f693c714413"
    sha256 cellar: :any,                 sonoma:        "98f3c70853ad31f59648535e41469c922230555a20a7d48bdeee5b4a2a7f9bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9925512c5cfd3651407aeebc9a7cff6a7683094ae2a03c1a9a82cbc36a444e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be949b3dae1bf89d693c6064ebd4c92b57d4900a6d60ff7fbb18c2b740a83fa1"
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
