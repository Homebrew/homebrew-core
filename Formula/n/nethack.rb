# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  license "NGPL"
  head "https://github.com/NetHack/NetHack.git", branch: "NetHack-5.0"

  stable do
    url "https://nethack.org/download/5.0.0/nethack-500-src.tgz"
    version "5.0.0"
    sha256 "2959b7886aac76185b90aea0c9f80d14343f604de0ae96b3dd2a760f7ab3bde9"

    # Fixes --showpaths command when used noninteractively,
    # required by Homebrew's tests
    # https://github.com/NetHack/NetHack/issues/1512
    patch do
      url "https://github.com/NetHack/NetHack/commit/60d59f4d5574c00cbb391cd58da3ed959de1ba2b.patch?full_index=1"
      sha256 "3ac9c71f360404c30845b67b8e96d06504c3039abe1ae43b76c856b20ee11f98"
    end

    # Second half of the above fix
    patch do
      url "https://github.com/NetHack/NetHack/commit/b7735632bfdac6a502f8f2954fbe6d5bbac53e2b.patch?full_index=1"
      sha256 "ea9a05446b9d840030c799d610bec394337040c2d63f8d3694f38221776e6d02"
    end
  end

  # The /download/ page loads the following page in an iframe and this contains
  # links to version directories which contain the archive files.
  livecheck do
    url "https://www.nethack.org/common/dnldindex.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "64c1e5e3881ad027b0863dec469eb70bb17c96d2682b0ca111c472e27ea685ef"
    sha256 arm64_sequoia: "cbe525013079e0b7036e3eb1ce549b738fe9a973e9d49a6209f2be4eaaad9f71"
    sha256 arm64_sonoma:  "ae526f9bb987bd3fd402f6eba3bb9ff12fe17d32db301e9649ece36c3e14bfc0"
    sha256 sonoma:        "dabec95206e3a906c55552727a6bbd346daa31ba7b8a9e7310ccf7ff915456c3"
    sha256 arm64_linux:   "27674cebca8e1f2cdaafe515b2562f4fe5e363d56b24915db408b7d59278101b"
    sha256 x86_64_linux:  "23c92a6f3d645059c8624d380fd8c2a31d995d902029a9589614a24db22b6a44"
  end

  depends_on "groff" => :build
  uses_from_macos "ncurses"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize
    # Fixes https://github.com/NetHack/NetHack/issues/274
    # see https://github.com/Homebrew/brew/issues/14763.
    ENV.O0

    cd "sys/unix" do
      hintfile = if OS.mac?
        "macOS.500"
      else
        "linux.500"
      end

      # Enable wizard mode for all users
      inreplace "sysconf", /^WIZARDS=.*/, "WIZARDS=*"

      # Enable curses interface
      # Setting VAR_PLAYGROUND preserves saves across upgrades
      inreplace "hints/#{hintfile}" do |s|
        s.change_make_var! "HACKDIR", libexec
        s.change_make_var! "CHOWN", "true"
        s.change_make_var! "CHGRP", "true"
        if build.stable?
          s.gsub! "#NHCFLAGS+=-DLIVELOG",
                  "#NHCFLAGS+=-DLIVELOG\nCFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/nethack\"'"
        end
      end

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    system "make", "fetch-lua"
    system "make", "install", "WANT_WIN_CURSES=1", "WANT_WIN_TTY=1"
    bin.install_symlink libexec/"nethack"
    man6.install "doc/nethack.6"
  end

  def post_install
    # These need to exist (even if empty) otherwise nethack won't start
    savedir = HOMEBREW_PREFIX/"share/nethack"
    mkdir_p savedir
    cd savedir do
      %w[xlogfile logfile perm record].each do |f|
        touch f
      end
      mkdir_p "save"
      touch "save/.keepme" # preserve on `brew cleanup`
    end
    # Set group-writeable for multiuser installs
    chmod "g+w", savedir
    chmod "g+w", savedir/"save"
  end

  test do
    system bin/"nethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/nethack").to_s,
                 shell_output("#{bin}/nethack --showpaths")
  end
end
