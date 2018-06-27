class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.5.tar.gz"
  sha256 "6b41f2aaa81d956339a2c20193d10a6c2bcd0e47ac2f382a6c525058803aefa7"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "36e265a0b1bb3d17500d0c6bb0ffcd7856daea27d98a403645bef7060eb0bc2f" => :high_sierra
    sha256 "54cadfa3d82ef0c5554241975c848f754e89dc43b222d0863e446379b8aedae1" => :sierra
    sha256 "7f8a593fc769bb7701810f5dc91a6d0a0e5e75c37c540df60715a21d96298f39" => :el_capitan
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
