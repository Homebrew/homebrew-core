class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.1.4.tar.gz"
  sha256 "ad2e6b74317434d9f76dda6e179c879ece2437808a4f4d134a842ca8d3f877de"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "37d81909dcd30da9129de4b34ce09932800c96f91a8d3cb88171918ed0cafa94" => :high_sierra
    sha256 "b846f7757d45a4eed260f39f2b5e72b117140bd5208b602220420b751cf2ec41" => :sierra
    sha256 "ec7da3fa4b68b188f6a7e1ec2d99ce16245d85562114ec146f0e17f40a508f34" => :el_capitan
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
