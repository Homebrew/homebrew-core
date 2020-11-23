class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/2.3.1.tar.gz"
  sha256 "12004cfed7ed083911dbda3228a9fb9ce6e40e259b34e791d970c4f335935fa3"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/plenv.git"

  bottle :unneeded

  depends_on "perl-build"

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system "#{bin}/plenv", "rehash"
  end

  def caveats
    <<~EOS
      To enable shims add to your profile:
        if which plenv > /dev/null; then eval "$(plenv init -)"; fi
      With zsh, add to your .zshrc:
        if which plenv > /dev/null; then eval "$(plenv init - zsh)"; fi
      With fish, add to your config.fish
        if plenv > /dev/null; plenv init - | source ; end
    EOS
  end

  test do
    assert_match(/\* system \(set by/, shell_output("#{bin}/plenv versions"))
  end
end
