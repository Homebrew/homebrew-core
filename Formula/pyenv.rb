class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.0.tar.gz"
  sha256 "80b5f5ecd92f5874bd5b4d775d2c57d0f2094287e27a61750360f39fcf32770d"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c2a9311f69d53462ccb1f210264302481260741064be2faa7a70f69c75673a20" => :high_sierra
    sha256 "a8e9cb1e87e53e5332bea57303ec50e90cb1697bf67949b4a11d63850adc2e18" => :sierra
    sha256 "c4106c40d7b9dc3b8dfa533e3710f7c8fba12d2fdd410a00a0c0608ac5ed16ed" => :el_capitan
  end

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    bash_completion.install "completions/pyenv.bash"
    fish_completion.install "completions/pyenv.fish"
    zsh_completion.install "completions/pyenv.zsh"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
