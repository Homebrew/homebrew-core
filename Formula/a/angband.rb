class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://github.com/angband/angband/releases/download/4.2.5/Angband-4.2.5.tar.gz"
  sha256 "c4cacbdf28f726fcb1a0b30b8763100fb06f88dbb570e955232e41d83e0718a6"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "56b2ccd6f86112f7f3c8b97100252d4d39d49be6a659dabbaffd9e393c1d4db1"
    sha256 arm64_sonoma:  "8c10f616a3f00c8950337ef5bb75494ab170230efdf3c24a20d92b134becdb3a"
    sha256 arm64_ventura: "8f7a2ba62953feedc36fc0581b683aea811ccf8fc8e261385abd6275c6717625"
    sha256 sonoma:        "091bad28afd7bad19504a1153d7bd6e44871975927cc62f5363fb55c866ec938"
    sha256 ventura:       "75ae7f63506954778d1dfede17083c865cb49bbabec6df92fce979206e42feb4"
    sha256 arm64_linux:   "72e0ca41e7634c6783d80320a98e0d23345bb7d7e407e60a679b79fe52d74682"
    sha256 x86_64_linux:  "453011c94bc2555692b32716a63a88f14b55562677069daf88bef76db98976ea"
  end

  head do
    url "https://github.com/angband/angband.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_system :linux, macos: :sonoma_or_newer do
    depends_on "ncurses" # ncurse5.4-config is broken on recent macOS
  end

  def install
    args = %W[
      --bindir=#{bin}
      --enable-release
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    if OS.mac? && MacOS.version < :sonoma
      ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
      args << "--with-ncurses-prefix=#{MacOS.sdk_path}/usr"
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
