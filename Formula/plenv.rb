class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/2.3.0.tar.gz"
  sha256 "49ea2770627f40d1fafccf03bf459839bf1d005b3d8c3c5772f0242c84423876"
  head "https://github.com/tokuhirom/plenv.git"

  bottle :unneeded

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system "#{bin}/plenv", "rehash"
  end

  def caveats; <<~EOS
    To enable shims add to your profile:
      if which plenv > /dev/null; then eval "$(plenv init -)"; fi
    With zsh, add to your .zshrc:
      if which plenv > /dev/null; then eval "$(plenv init - zsh)"; fi
    With fish, add to your config.fish
      if plenv > /dev/null; plenv init - | source ; end
  EOS
  end

  test do
    system "#{bin}/plenv", "--version"
  end
end
