class Goenv < Formula
  desc "Like pyenv and rbenv, but for Go."
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/v20160424.tar.gz"
  sha256 "911f6c72f542781e30191373c18bbd48eaabdae62bfbeef0ad705bdab0a77fb8"
  head "https://github.com/syndbg/goenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/goenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.goenv add to your profile:
      export GOENV_ROOT=#{var}/goenv

    To enable shims and autocompletion add to your profile:
      if which goenv > /dev/null; then eval "$(goenv init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/goenv init -)\" && goenv versions")
  end
end
