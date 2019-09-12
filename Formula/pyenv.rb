class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.13.tar.gz"
  sha256 "ebf9899f70cb04a6a6bf9835c37d9d7e4ed7dadb22dd8123b19d6d790a13fffe"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "02ca7b702210e4ff420e6bab6248487537a09c843e495042e569d784607056e6" => :mojave
    sha256 "fc4e014627b4a42b647c61219a7cf7882bca797104a2cc15d6243529593ee2eb" => :high_sierra
    sha256 "c863f6b200535131653787ee07647f9a042b44bfd54d3d065366542dd9b0be3a" => :sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
