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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "0df230a1880838e0d760e4ab52b810d4e14be0d1a56f72e1cfd3844bda5b63bd"
    sha256 arm64_sequoia: "4254054eebe14f564aaacfd35f1213ec0dc2e487a090c8e0bd8d9f0db7d6233a"
    sha256 arm64_sonoma:  "e26f6a013fe24f7ae2f3809fc4b694ac9670a71a04c8cd562da2e077f3d63db5"
    sha256 sonoma:        "61a26d4ff8e1da2020f0f50f094b8119fb6b1edd3ab329ed8a316a5974d976d9"
    sha256 arm64_linux:   "ee5dfc8cb392c6432a078fb87b9758af0160f5a726174dcd804702b38ae20473"
    sha256 x86_64_linux:  "91bee3bb1ebbaaae4618343307faf157d08c8876753023d86d7a29eea187ce59"
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
