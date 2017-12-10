class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.0.tar.gz"
  sha256 "80b5f5ecd92f5874bd5b4d775d2c57d0f2094287e27a61750360f39fcf32770d"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "dd8f32589db44346063d6f728509af2ecde935c2bef57d6d2ca82c3aec8c5168" => :high_sierra
    sha256 "869ababc02dd9599ed6320e882ff03c2670bd65c0facaa1d751112761e3f23fe" => :sierra
    sha256 "c7898176f63fb9f98ba8b715f58e695a1ae052b80d3c1e96a1af6776c58218e7" => :el_capitan
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
