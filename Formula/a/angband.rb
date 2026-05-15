class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://github.com/angband/angband/releases/download/4.2.6/Angband-4.2.6.tar.gz"
  sha256 "8c0ffa2b85d74bd0cc273752f61c0440dba93323cd790be460f90c8dced7cbf4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d4aef25f1be9724500e460e68ca2da76fd2294d56e4467bb4f85b156e5193934"
    sha256 arm64_sequoia: "be8f704be3323d08b76ab1fa16b997450dd9b0aed4d7895d56c2ca591c64756a"
    sha256 arm64_sonoma:  "28a7168d8525d3c7ac48111b79be016734228d1ea60e7e96105094c44caf99f0"
    sha256 sonoma:        "d6eab62f0ab0ed7f927fbec829699d7d345bc40b21dbdefb86ef2719e3a1a587"
    sha256 arm64_linux:   "c3ed6d0c2f79f256df6f136700eeea2f123ff8cd5e4785184062802682f262c7"
    sha256 x86_64_linux:  "b2f09d71bee68e3c1b051d87ead34426cf2ce64af363afa7b24f9f72bdd0bbf9"
  end

  head do
    url "https://github.com/angband/angband.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    args = %W[
      --bindir=#{bin}
      --enable-release
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    if OS.mac?
      sdk = MacOS.sdk_for_formula(self).path
      ENV["NCURSES_CONFIG"] = "#{sdk}/usr/bin/ncurses5.4-config"
      args << "--with-ncurses-prefix=#{sdk}/usr"

      # ncurse5.4-config is broken on recent macOS and will return nonexistent -lncursesw
      if MacOS.version >= :sonoma
        (buildpath/"brew").install_symlink sdk/"usr/lib/libncurses.tbd" => "libncursesw.tbd"
        ENV.append "LDFLAGS", "-L#{buildpath}/brew"
      end
    end
    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    require "expect"
    require "pty"

    timeout = 10
    args = %W[
      -duser=#{testpath}
      -darchive=#{testpath}/archive
      -dpanic=#{testpath}/panic
      -dsave=#{testpath}/save
      -dscores=#{testpath}/scores
    ]

    PTY.spawn({ "LC_ALL" => "en_US.UTF-8", "TERM" => "xterm" }, bin/"angband", *args) do |r, w, pid|
      refute_nil r.expect("[Initialization complete]", timeout), "Expected initialization message"
      w.write "\x18"
      refute_nil r.expect("Please select your character", timeout), "Expected character selection"
      w.write "\x18"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
