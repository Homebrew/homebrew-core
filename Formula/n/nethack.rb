# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  license "NGPL"
  revision 1
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
    sha256 arm64_tahoe:   "4ed420ea146cea8d1db4e8db8b21471a5058ece3e714696f754765365264f115"
    sha256 arm64_sequoia: "6c778031601539eaa003d5350ef383311832157e313c75b2f95ce2e726e924cf"
    sha256 arm64_sonoma:  "62417badde3fbbd385613140aefd6f72271cf24397cdc2f713cfcc1d96cfb8b1"
    sha256 sonoma:        "e66b26d59fdb22fe8c8b5516cfb56771ebbcd4893e37c99326b3a073c8c06b9d"
    sha256 arm64_linux:   "7eed963a9502ddabe4314e4c06afdc60453b5e7d4d9172605946081ea888a15c"
    sha256 x86_64_linux:  "a7e677736166fa625a926028c41097d40535b6dd8ac19dd6ad27aabf027ee623"
  end

  depends_on "groff" => :build
  depends_on "ncurses"

  # Fix save (de)compression path when the playground differs from HACKDIR.
  patch do
    url "https://github.com/NetHack/NetHack/commit/4a04a897a76d5d9ea79cb777832ce2057f4edd48.patch?full_index=1"
    sha256 "b353538d07b044307dcd7f0b569ba66a9bc715d5b40e35a7bf33cf69500f42fd"
    type :unofficial
    resolves "https://github.com/NetHack/NetHack/pull/1629"
  end

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
      if build.head?
        inreplace "hints/include/dirs-perms.500" do |s|
          s.change_make_var! "HACKDIR", libexec
          s.change_make_var! "CHOWN", "true"
          s.change_make_var! "CHGRP", "true"
        end
        inreplace "hints/#{hintfile}" do |s|
          s.gsub! "#-POST", "CFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/nethack\"'\n#-POST"
        end
      else
        inreplace "hints/#{hintfile}" do |s|
          s.change_make_var! "HACKDIR", libexec
          s.change_make_var! "CHOWN", "true"
          s.change_make_var! "CHGRP", "true"
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

  post_install_steps do
    mkdir_p "{{HOMEBREW_PREFIX}}/share/nethack/save"
    touch "{{HOMEBREW_PREFIX}}/share/nethack/xlogfile"
    touch "{{HOMEBREW_PREFIX}}/share/nethack/logfile"
    touch "{{HOMEBREW_PREFIX}}/share/nethack/perm"
    touch "{{HOMEBREW_PREFIX}}/share/nethack/record"
    touch "{{HOMEBREW_PREFIX}}/share/nethack/save/.keepme"
    set_permissions ["{{HOMEBREW_PREFIX}}/share/nethack", "{{HOMEBREW_PREFIX}}/share/nethack/save"], "g+w",
                    recursive: false
  end

  test do
    system bin/"nethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/nethack").to_s,
                 shell_output("#{bin}/nethack --showpaths")
  end
end
