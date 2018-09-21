class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v20.0/nzbget-20.0-src.tar.gz"
  sha256 "04dc36d432549c33d55145ecd95cc4309b3ab4a7731a1a03d954de389eacd06f"
  head "https://github.com/nzbget/nzbget.git", :branch => "develop"

  bottle do
    sha256 "6e9bb7d0fa4a14eba43d78cca17a4f8a24be119481ec3b1b4f017ebae99dedeb" => :mojave
    sha256 "e28994fadf8cb1c81dd90de7cec9427f2fb7cf2e26b26a5844f8931b58549d37" => :high_sierra
    sha256 "ac695e943c123fd8220c22ab9b164ec4f38aabc608f0b06d6415b85985991011" => :sierra
    sha256 "90cce93915e5013766ea3f1a6ad071e33891752e053773e95c2a847e56869320" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" if MacOS.version <= :mavericks
  depends_on "openssl"

  fails_with :clang do
    build 600
    cause "No compiler with C++14 support was found"
  end

  fails_with :clang do
    build 500
    cause <<~EOS
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
    EOS
  end

  needs :cxx11

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
