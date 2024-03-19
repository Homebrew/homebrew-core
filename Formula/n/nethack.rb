# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  license "NGPL"
  head "https://github.com/NetHack/NetHack.git", branch: "NetHack-3.7"

  stable do
    url "https://www.nethack.org/download/3.6.7/nethack-367-src.tgz"
    version "3.6.7"
    sha256 "98cf67df6debf9668a61745aa84c09bcab362e5d33f5b944ec5155d44d2aacb2"

    # add macos patch, upstream PR ref, https://github.com/NetHack/NetHack/pull/988
    patch do
      url "https://github.com/NetHack/NetHack/commit/79cf1e902483c070b209b55059159da5f2120b97.patch?full_index=1"
      sha256 "5daf984512d9c512818e0376cf2b57a5cd9eefaa626ea286bfd70d899995b5de"
    end
  end

  # The /download/ page loads the following page in an iframe and this contains
  # links to version directories which contain the archive files.
  livecheck do
    url "https://www.nethack.org/common/dnldindex.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "ce30c296e474a239cb110c54a7b16950de538e9782414718290606a8cc9424d1"
    sha256 arm64_ventura:  "e51292f937dbfdb68feb969552da8ab484a8728d5fb85fc6e389cdfd0ed57922"
    sha256 arm64_monterey: "f546283d68a22ff79a4a382a05fb9f7c1949b8057e52f478c8cead4300d424b4"
    sha256 arm64_big_sur:  "078ee2989d66bf8a98a577509c86dc4e7bddc009fe475dcfe172c075bd0cdb39"
    sha256 sonoma:         "496413acccb6c48f8ae064d8beed827062858948e4f28dd7e792ef256d6236ad"
    sha256 ventura:        "a2ca955b4f528e11d3d5baceeb8bb9783914f595a1a010e12ce23cc5206e85ef"
    sha256 monterey:       "0fad9d74cfab3770167a0de3de5228f2ec5c079e94d6956c140f820b3b8e2097"
    sha256 big_sur:        "9478349296901830cee4abfeecbca729453a87732753603216e6a7ca8b31695a"
    sha256 x86_64_linux:   "e8904c482b7915880b90dd409d7a66d74b46524d07071f3eb720aa870cf78a83"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize
    # Fixes https://github.com/NetHack/NetHack/issues/274
    # see https://github.com/Homebrew/brew/issues/14763.
    ENV.O0

    cd "sys/unix" do
      hintfile = if OS.mac? && MacOS.version >= :mojave
        build.head? ? "macOS.370" : "macosx10.14"
      else
        build.head? ? "macosx.sh" : "macosx10.10"
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
          s.gsub! "#WANT_WIN_CURSES=1",
                  "WANT_WIN_CURSES=1\nCFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/nethack\"'"
        end
      end

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    system "make", "fetch-lua" if build.head?
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
    system "#{bin}/nethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/nethack").to_s,
                 shell_output("#{bin}/nethack --showpaths")
  end
end
