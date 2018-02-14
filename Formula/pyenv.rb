class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.1.tar.gz"
  sha256 "a2a27ff60cd567a73eed2ed4596e5a99d45282df4f4e5d247f08e76f7f5db8ba"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93b76626887e04e7583af3e3e517f25668e786031362e9f921a3742264b85fc4" => :high_sierra
    sha256 "79c347c4d1b53b71a5e7cbae73f2c9b7afbc26d0435c219bd43e4653ec6c8847" => :sierra
    sha256 "7e3e4ae092924c2404e4041d22dbe29a16f90713a375ff157b06622515e90efa" => :el_capitan
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
