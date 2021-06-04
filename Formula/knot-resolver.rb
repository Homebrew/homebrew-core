class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.3.2.tar.xz"
  sha256 "8b6f447d5fe93422d4c129a2d4004a977369c3aa6e55258ead1cbd488bc01436"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "a7ea8a46735ba271c77d9222164b1b59d6c24804cba79784f06efbce28749b90"
    sha256 catalina: "d53612425f1a690289bd46524551f2d13cef6486b5bb9389089165c4e3fca33d"
    sha256 mojave:   "01c96cd6fc7804f1ec6520a90c023f7fc760a5be69db3d4b3cdf581d13a70714"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "--default-library=static", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{var}/knot-resolver</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/kresd</string>
          <string>-c</string>
          <string>#{etc}/knot-resolver/kresd.conf</string>
          <string>-n</string>
        </array>
        <key>StandardInPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/knot-resolver.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
