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
    sha256 arm64_monterey: "a35fe8d9924485cd51dceb3ba4cd1c915bfc65b6b1bd8eb7f67a9fc5e505fe42"
    sha256 arm64_big_sur:  "94495ff709647df63efa6c16f22f5be1de4ac52c404047fadcbb08a4aef55a3e"
    sha256 monterey:       "b68729b3a66c3c3f4777af5e5abf53752a192773f5c2f9a2ef9dea5844e95808"
    sha256 big_sur:        "925eb3391381b336266c068b43779d7ebfd22aba15a9e61fba4b853cba4dc624"
    sha256 catalina:       "f34102aa4cd0341970481bbca15a98de6021d68b493c5e9ba4f882a79745e5c3"
    sha256 x86_64_linux:   "3cfa3f60f7b88f2aa13cbbcae6b90e0aec128f5aef92e49c2860e61075c32af3"
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
