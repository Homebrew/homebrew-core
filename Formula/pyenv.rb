class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.2.tar.gz"
  sha256 "7ff9b7cada231b72d7802dbf542c17b8ad7a5efdfb3b127056bb063c822269fe"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "c7159f9e5e60f355a5ee23bce257cce5fca1acfb8df858626289ba924c4c4471" => :high_sierra
    sha256 "c88587f35c9596cec32daf6180c9f247888a5493927849341ac3e1a50ca703cd" => :sierra
    sha256 "a6e9c83d71ef35255fa682c58e66268a2c3c8d7545247ec7e3c9695960715342" => :el_capitan
  end

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

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
