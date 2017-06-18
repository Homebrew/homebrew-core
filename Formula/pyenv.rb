class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.1.1.tar.gz"
  sha256 "8f58618b42d2cac273a2fa301720aa064da63b7c70c24cc9404e526e280930e7"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "a50de7946100ce6f44398470ec75b3038a4cfa780b96f79ed02037a68845def6" => :sierra
    sha256 "2d9e804072c3188eb953419450683e1bd4b2a80ee7f8be467e3b46aaa092cf89" => :el_capitan
    sha256 "f331e645df649b1fa25579429d49643801629791d687c75387e4455d5fb1a06f" => :yosemite
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
