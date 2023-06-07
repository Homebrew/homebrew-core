class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://angband.github.io/angband/"
  url "https://github.com/angband/angband/releases/download/4.2.4/Angband-4.2.4.tar.gz"
  sha256 "a07c78c1dd05e48ddbe4d8ef5d1880fcdeab55fd05f1336d9cba5dd110b15ff3"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/angband/angband.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ab48df2a071152b29ae786420ea97bccfeb2c19f70b58fff6b38760a5879ef04"
    sha256 arm64_monterey: "b9e8cf65e54b880cee6c5d1a0813a7dd2feb38913ac652ad858e125feedff281"
    sha256 arm64_big_sur:  "33e848319750163d7ce2f2b8ea4a7b71ea5232597f7f18fa65797d0457510d6e"
    sha256 ventura:        "4c1f79b6fa609020ecc110841406019761dabf2d6e0b71605f2c512f2453ee3d"
    sha256 monterey:       "8b0fadd166bea74a197f979712ff806c2e88a9f8968a4b886c72aa41e84d53e9"
    sha256 big_sur:        "15ce407b3c208768e41a9845cbb2250d476e293e9c749a7a1e997d73e0ddcaa5"
    sha256 catalina:       "cfdb08365d8239c8609d22b234bca681bbca6a91f68db9c771a2664e5e1d6229"
    sha256 x86_64_linux:   "be5f345f715dec51d3fcaa0c8d408355768f6386f7579913f65f1b3726bdf376"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config" if OS.mac?
    args = %W[
      --prefix=#{prefix}
      --bindir=#{bin}
      --libdir=#{libexec}
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    args << "--with-ncurses-prefix=#{MacOS.sdk_path}/usr" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 10
      spawn angband
      sleep 2
      send -- "\x18"
      sleep 2
      send -- "\x18"
      expect eof
    EOS
    system "expect", "-f", "script.exp"
  end
end
