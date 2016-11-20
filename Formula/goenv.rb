class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/v20161028.tar.gz"
  sha256 "3f283537c2b4f64a7549a009361ac4da6115be6b2c45462b008a58f8366a8804"
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
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
