class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.1.tar.gz"
  sha256 "a2a27ff60cd567a73eed2ed4596e5a99d45282df4f4e5d247f08e76f7f5db8ba"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "80a9b87c2d5c55ac311bb0f1e3e68fb8d27d0733c1e778f1f636a75973ad7185" => :high_sierra
    sha256 "d996123820eda42f74237dba6780952b62f0a489ed4f235acd2e9f52510c7a55" => :sierra
    sha256 "a97fa7ddb700c607a1d3185072c6aae210b7bfed645be4c8d89e5e8a93662cd7" => :el_capitan
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
