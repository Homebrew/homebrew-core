class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.14.tar.gz"
  sha256 "3062c104b200d8c572d185b54e73a94bf66d5d46cc789717c372d2941c314a93"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "b2378067acc0a2472e532e2628bf69814ab0bd243253bf056c6a637283393fe6" => :catalina
    sha256 "5eabfc9dfb8ed38d566ef3ad42fd4a677a11b58cdbb74e7c715533bce7d15257" => :mojave
    sha256 "ca3f33c0340ebc5c2118a009352b8a9dbf7f33b685d72c3516e15466e0127730" => :high_sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

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
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
