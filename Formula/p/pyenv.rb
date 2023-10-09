class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.29.tar.gz"
  sha256 "86af7d251e5691c5537b939a5444718d3811c8b9d70b78ffaf51fd71897437fb"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26ae008b2d10c5820dd9ae57c82af2e59112084f71d566e5579cac71d411417c"
    sha256 cellar: :any,                 arm64_ventura:  "6aeab5951fdcfd4ae5697f1bfa04d7e523d111bfd44d358b0dce22eba7b88355"
    sha256 cellar: :any,                 arm64_monterey: "1680c7780bf9929f4252d69591689657b30845b036f429ebfce8180f4d9a210b"
    sha256 cellar: :any,                 sonoma:         "03cc5c3e9200f572d6c53a7d7d60694a09d12a041d2f4b8ffd606f9af26eb813"
    sha256 cellar: :any,                 ventura:        "cdcf423b2fd145131800d1a59dd3f381c4ff0bbcb6b58109641a75e335860101"
    sha256 cellar: :any,                 monterey:       "c2b9fe8510250fbf4d21948e960c5be7e72634f1e7848277a8ffa2306a31e096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4246a21a5ecf7e9f0578fb774beb06064a8665c77b7e1a4ce8d140415a378c"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"
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
