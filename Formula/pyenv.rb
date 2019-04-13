class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.11.tar.gz"
  sha256 "3756c0e386c3a6a6b36f2f8d6cc55441cc3aae1190f74c01f15d7dcdc0cae6fa"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "acae690d661eff69b54b66aa90c69f5254c546e23a7bc6b5447897e9024c48f6" => :mojave
    sha256 "449bb8952ea6aba7f0534f3259bea479cd7464f1c24378f8d433a6048c4bd0e6" => :high_sierra
    sha256 "342fbf05f62973a4123e53c1420506f99023378e2c0574e93b2fc995699a3df3" => :sierra
  end

  depends_on "autoconf"
  depends_on "openssl"
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
