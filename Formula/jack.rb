# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of macOS
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/Homebrew/homebrew/pull/22043 for more info
class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  # pull from git tag to get submodules
  url "https://github.com/jackaudio/jack1.git",
      :tag      => "0.125.0",
      :revision => "f5e00e485e7aa4c5baa20355b27e3b84a6912790"
  revision 4
  head "https://github.com/jackaudio/jack1.git"

  bottle do
    sha256 "69f9c5215e993b4b6eee2b31b3585d4df92160ec162a433df76a4a66e9f72b71" => :catalina
    sha256 "fc489e40c89bfe3315b7d9f6dc1f243aeb03e57741faeb7b4b8f8adfc769c0a7" => :mojave
    sha256 "169ce5413c397a9cea4d346fd33d5120f1411d92105f39722b2ae8c9ebd881df" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  uses_from_macos "util-linux"

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    # Makefile hardcodes Carbon header location
    inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
      "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
      "#{sdk}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"

    # https://github.com/jackaudio/jack1/issues/81
    inreplace "configure.ac", "-mmacosx-version-min=10.4",
                              "-mmacosx-version-min=#{MacOS.version}"

    system "./autogen.sh"
    ENV["LINKFLAGS"] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "jackd -d coreaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
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
