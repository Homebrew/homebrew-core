class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.6.tar.gz"
  sha256 "df9449f69918c716e688d4216eb4398d2cd6d2dcd0f7e6f56d55d19d74cc57cc"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "65df3cf10a2eebf6f70703ccce505eed87d5114ba5c2e3fe838433bd5a869eba" => :high_sierra
    sha256 "0835194be459d1958a0023770ac007ae5c19b6e014a6059219364e8280593b73" => :sierra
    sha256 "d267f79456e19099871d74d8f1710e8041d52ab7b1ea925107b5ce6d513c2e47" => :el_capitan
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
