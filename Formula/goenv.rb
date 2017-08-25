class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/1.3.0.tar.gz"
  sha256 "c7387181d7791b26456a707770fedc74ede3b684130976fbfc6f61382222ec3e"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/goenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
