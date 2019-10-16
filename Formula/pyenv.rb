class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.14.tar.gz"
  sha256 "3062c104b200d8c572d185b54e73a94bf66d5d46cc789717c372d2941c314a93"
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "836873ee74686abdfd7912be9fc55de29f5b10b355330257da796d8919dd5720" => :catalina
    sha256 "b4465f65f302ab62e847e96dcd8870a64febb0573cd0c9dd2b65952fbce0007b" => :mojave
    sha256 "159f2ceaeb5fb37d8cc7d01999718f3386b527b6e4dbbe6f54233b4aa80c4adc" => :high_sierra
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
