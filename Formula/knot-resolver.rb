class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.1.2.tar.xz"
  sha256 "caa4f941caf39080184554fb1310f383eba4b30d9c4c2215670d6b0a2de8f836"
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  bottle do
    sha256 "341d13941123e359dc5f1cb6147e6058296691c95ea2cfe4a2a436d1125ae9e1" => :catalina
    sha256 "7a861d87a84b2e8572bb9b76fbd3768b516821dc046c1a34f1d27caa4b511748" => :mojave
    sha256 "5050ebacd49658cde25168edc4e40575dfb1934b554eac5b1e28c29dfc520cea" => :high_sierra
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

  # DNSSEC root anchor published by IANA (https://www.iana.org/dnssec/files)
  def root_keys
    <<~EOS
      . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
    EOS
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
        <string>#{var}/kresd</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/kresd</string>
          <string>-c</string>
          <string>#{etc}/kresd/config</string>
          <string>-f</string>
          <string>1</string>
        </array>
        <key>StandardInPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kresd.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"kresd", "--version"
  end
end
