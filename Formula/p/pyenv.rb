class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "78cf6865c9514e90ff0e464fa3ec867870f3437a5ee2bc0f73240adb328b9f26"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6d9edeec3354839bf5f6843cf7a2437d1109854a5acd2bc3ab4d63a8e2ac17a"
    sha256 cellar: :any,                 arm64_ventura:  "7ef621d7242be077c90c3afe8c9fccaf05178572732c471475881a31e2f3a4c5"
    sha256 cellar: :any,                 arm64_monterey: "a792cfe55fe6532927cc9d1a0ed4289c5ba48760f2ebc6c88fa8114db61cf3b3"
    sha256 cellar: :any,                 sonoma:         "5979d8584412d208c09636595d74a79c28c8b998b7e850ffe54a00b2e77e4c9e"
    sha256 cellar: :any,                 ventura:        "14b73238dc60ef8b5cc689ca2c41a93b658d6351ad6edaf0829ded7ff1fae037"
    sha256 cellar: :any,                 monterey:       "c2ad083394067eead5e0fe9d9de76a2c0f133f9e2da1f7522045a6cf59bff7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63fd85aa23136de0a0e8fc0d7fa120af24c816124b5cb9dc8ac91630a0afe4cd"
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
