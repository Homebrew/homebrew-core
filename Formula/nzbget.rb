class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "http://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v17.0/nzbget-17.0-src.tar.gz"
  sha256 "795c830344dcc8751a2234a8344190b3f3e48e1ce92dcff02ee0af95a5fa46ae"
  head "https://github.com/nzbget/nzbget.git"

  bottle do
    cellar :any
    sha256 "c69d482944ac626ae8869913f21f343e2a6fbd40c2043d35a9b5470e2ff03da2" => :el_capitan
    sha256 "724965734679a54c8c8c829a725dd69b8225c203b2b1575954ccedaa0e45f5d7" => :yosemite
    sha256 "0336f67f14a4de0a37983d8acc001b72a66892a5d77b79e2dd1f9b77f489bf04" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gcc" if MacOS.version <= :mavericks

  needs :cxx11

  fails_with :clang do
    build 600
    cause "No compiler with C++14 support was found"
  end

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
      EOS
  end

  def install
    ENV.cxx11

    # Fix "ncurses library not found"
    # Reported 14 Aug 2016: https://github.com/nzbget/nzbget/issues/264
    ENV["ncurses_CFLAGS"] = "-I/usr/include"
    ENV["ncurses_LIBS"] = "-L/usr/lib -lncurses"

    # Tell configure to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make", "install"
    pkgshare.install_symlink "nzbget.conf" => "webui/nzbget.conf"

    # Set upstream's recommended values for file systems without
    # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
    inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
    inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"

    etc.install "nzbget.conf"
  end

  plist_options :manual => "nzbget"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/nzbget</string>
        <string>-s</string>
        <string>-o</string>
        <string>OutputMode=Log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D"
    # Query server for version information
    system "#{bin}/nzbget", "-V"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q"
  end
end
