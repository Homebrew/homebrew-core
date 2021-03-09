class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.3.0.tar.xz"
  sha256 "fb6cb2c03f4fffbdd8a0098127383d03b14cf7d6abf3a0cd229fb13ff68ee33e"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "f007354c76fdd4af09945fa548dc3889deab4e84c5bd1f1c206c109febd54b11"
    sha256 catalina: "62e84d19b85449c3bda7b7b177449143c69864c72a10c2251b35c016bd779d3a"
    sha256 mojave:   "562be32a5e4504b9f2bebeb4043d36efc6e21b6a7c13578d2228ab6f1a9545b8"
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
    assert_path_exist var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
