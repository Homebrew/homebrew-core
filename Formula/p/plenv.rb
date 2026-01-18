class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/refs/tags/2.3.1.tar.gz"
  sha256 "12004cfed7ed083911dbda3228a9fb9ce6e40e259b34e791d970c4f335935fa3"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/plenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5a0466e4db621c88c365d43a2833a11f9fb5c8284c906b34e2d8d71365370d31"
  end

  depends_on "perl-build"

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system bin/"plenv", "rehash"

    # Build an `:all` bottle
    inreplace libexec/"plenv", "/usr/local/etc/plenv.d", "#{HOMEBREW_PREFIX}/etc/plenv.d"
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
