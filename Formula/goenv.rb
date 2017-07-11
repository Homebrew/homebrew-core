class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/1.2.1.tar.gz"
  sha256 "88de39a3b2ddaa3c3d9700b5866146b960b8fb774eda661e5c68d67b6b751c71"
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
