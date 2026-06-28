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
    rebuild 2
    sha256 arm64_tahoe:   "3b408742a63c852cf11455a3c86255fd4515a7e06971d6b51301bbaca0bf701d"
    sha256 arm64_sequoia: "828b593da16e8483ba2e2ee4a6c926130e6cb5f61141399ea91b81ccba7d34c4"
    sha256 arm64_sonoma:  "d5d11cc6a399fe43749986745a51b80931ebf376bd75d80beb30c9b58265ab53"
    sha256 sonoma:        "b06719b309b4c5c02dc0a506f68740f4ac01cb0379ecc52d7e903dd4a10f72dc"
    sha256 arm64_linux:   "8af171a7dee4d8421abb172f5fdefe0c8a2f39da72c80594aaefd32502ba3050"
    sha256 x86_64_linux:  "9f5613cc7fe579a4932a39f4e12bb841d31208b26b45bf864071c28a2eeb8313"
  end

  depends_on "groff" => :build
  depends_on "ncurses"

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
