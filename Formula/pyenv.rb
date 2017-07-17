class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.1.3.tar.gz"
  sha256 "5549cfe37cee6be20d434dd9dfc8cb8e715a8cdbfc4fa5a8b7d735681cf1a69f"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "e149b02f3afdbbdf64a33796ca0539de30528b68c941fc53eb115db8b1350e0d" => :sierra
    sha256 "5e79f6b4250bdbc7cd54576164218eb394bc907468c2044826f27303568b9b08" => :el_capitan
    sha256 "d1a210c9ab9b8b16868d87a9d19ba39b7fa73322fd5d4059ccb6a6bc54a43675" => :yosemite
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
