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
    sha256 arm64_tahoe:   "263f45d084336797c0d218b49fa8569039f7ed227ea59e10135f585b2a3b39a0"
    sha256 arm64_sequoia: "d8355aeffe5789f86375979287c62fe720c8d0e6472543b0da9d2a17f60f4535"
    sha256 arm64_sonoma:  "a9132b7b68acda7a4def72459ef19bd3f45b54c650d7af7276f16540970e07bc"
    sha256 sonoma:        "f02f8d45ea8cdffed20400ecb0c6f3c33a185ad8dd70c45a214bec52b2feea62"
    sha256 arm64_linux:   "340fd39677a8b56e30acecc47c33b69618c0f8319bd6b91d1c975764246d095b"
    sha256 x86_64_linux:  "0f72ae46bf187e2c0e507b2504c39cd3f94872f3ac2ac86a5b5c7ed1de6e016e"
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
    system "make", "install"
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
