class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.3.tar.gz"
  sha256 "cb76cdd39c9207960d3c64b919b1d48376772e7f105953d877c658f2497e4d52"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "c7159f9e5e60f355a5ee23bce257cce5fca1acfb8df858626289ba924c4c4471" => :high_sierra
    sha256 "c88587f35c9596cec32daf6180c9f247888a5493927849341ac3e1a50ca703cd" => :sierra
    sha256 "a6e9c83d71ef35255fa682c58e66268a2c3c8d7545247ec7e3c9695960715342" => :el_capitan
  end

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended
  depends_on "readline" => :recommended

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
