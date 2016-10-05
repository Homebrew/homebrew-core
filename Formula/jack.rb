# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of Mac OS X
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/Homebrew/homebrew/pull/22043 for more info
class Jack < Formula
  desc "Jack Audio Connection Kit (JACK)"
  homepage "http://jackaudio.org"
  url "http://jackaudio.org/downloads/jack-audio-connection-kit-0.125.0.tar.gz"
  sha256 "3517b5bff82139a76b2b66fe2fd9a3b34b6e594c184f95a988524c575b11d444"

  bottle do
    sha256 "09037cc758f7fbb1906e9f57722143ac6fad688dafc8a3737b23ee6cf60f3277" => :sierra
    sha256 "538c6769165c651170287b466aadd693622430a4b3df917277faa4dcef9e36a9" => :el_capitan
    sha256 "e605e6c982263cf1e058ac67c130273caec43aec75371b907ad3a04ec5e212d8" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libsndfile"
  depends_on "libsamplerate"

  def install
    # Makefile hardcodes Carbon header location
    inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
      "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
      "#{MacOS.sdk_path}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"

    ENV["LINKFLAGS"] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "jackd -d coreaudio"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{prefix}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/jackd</string>
        <string>-d</string>
        <string>coreaudio</string>
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
    assert_match version.to_s, shell_output("#{bin}/jackd --version")
  end
end
