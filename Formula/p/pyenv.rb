class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.35.tar.gz"
  sha256 "ccf543a1c34126fe44a6899467210d81a3c2b95cc3769fc324c5ddb4a35707fc"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d19469261f788c09404f05872bd75357213ee58e98426e05edb962962d5e1a06"
    sha256 cellar: :any,                 arm64_ventura:  "097dfe00661f64d388d9afd9c11059f8e5bb01a19d40c263fb1b41277cc9fb8c"
    sha256 cellar: :any,                 arm64_monterey: "a1ec67316f2a6b81ae4df03b014b1dd62c3ba5b14579204ec3bd1a3605314ada"
    sha256 cellar: :any,                 sonoma:         "9290ef7a95f4be7c6bcb5cd8ee17566ed8f3fe106e5a93f9dcc59b0c9c7e90d5"
    sha256 cellar: :any,                 ventura:        "a4c0d3cb06c7e18b6c38ddb3b53d922008ac5c639a43918eb87f4d9c9c154435"
    sha256 cellar: :any,                 monterey:       "53b6fa514e3dc4c667ae01ec0d1e0f1a1ec6e1e064843ea70ab8eb65c8bee6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15af716d9e687a5a786ed0216996fe4443ddba316fac652c67ab7c5c0880a97"
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
