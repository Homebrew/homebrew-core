class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v21.0/nzbget-21.0-src.tar.gz"
  sha256 "65a5d58eb8f301e62cf086b72212cbf91de72316ffc19182ae45119ddd058d53"
  revision 1
  head "https://github.com/nzbget/nzbget.git", :branch => "develop"

  bottle do
    sha256 "d44d1a8dbd26f5cdb307c08f3294bd381ca79d51c48f51df98ae10a19272397e" => :catalina
    sha256 "1d69e26d929d2a1be4824ea8c2134d543033462302bc5527269d5ca7b1b2c575" => :mojave
    sha256 "862bd9889d1590b8e3f600419f2bbf84f1ea7582ed55c58eccc024382d6db245" => :high_sierra
    sha256 "2e174f6c4df74ef3cd5decca500963db0c99d71553da624693ec4e9d085a0a56" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" if MacOS.version == :mavericks
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    # Fix "ncurses library not found"
    # Reported 14 Aug 2016: https://github.com/nzbget/nzbget/issues/264
    (buildpath/"brew_include").install_symlink MacOS.sdk_path/"usr/include/ncurses.h"
    ENV["ncurses_CFLAGS"] = "-I#{buildpath}/brew_include"
    ENV["ncurses_LIBS"] = "-L/usr/lib -lncurses"

    # Tell configure to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.deparallelize
    system "make", "install"
    pkgshare.install_symlink "nzbget.conf" => "webui/nzbget.conf"

    # Set upstream's recommended values for file systems without
    # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
    inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
    inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"

    etc.install "nzbget.conf"
  end

  plist_options :manual => "nzbget"

  def plist; <<~EOS
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
