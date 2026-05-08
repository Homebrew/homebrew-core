class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.29.tar.gz"
  sha256 "dc6c5ae60e502c32522210a0365454c4e2aa56364695e412ca343f97a5930313"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e77680e28b12e13c37343c4ad508bc246613a6aaeaaa26150911d8de3650af7"
    sha256 cellar: :any,                 arm64_sequoia: "1c275d639b4a32869d8416ec2c5f67252e4ab66e366227b14331f69bf7de95ba"
    sha256 cellar: :any,                 arm64_sonoma:  "64de6e50f597cb34cd5c19b3da0ab04cb424c902139e5456d053caabef5e0071"
    sha256 cellar: :any,                 tahoe:         "120a1d910e1afef220630b714e2ed75a21460385ecd78b8d668b8ec6f71707bb"
    sha256 cellar: :any,                 sequoia:       "d60debda328ffdcd8f241e0817433cae7df62c6a51c6518ee7acc4120d11fb95"
    sha256 cellar: :any,                 sonoma:        "d2d7b6306281cb699fa0c5b135dcc69899c0fa1ebe0642107818f00d368d6fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3aa96460f0cedefd78d5955d9e6926debb0003ca26b8f7a331f323018d685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc251e34bf11490c5cd69e736318ec6c7fb6ebb043073788ae1c6e153910e71"
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
