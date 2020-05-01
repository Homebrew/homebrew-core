class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.0.1.tar.xz"
  sha256 "4a93264ad0cda7ea2252d1ba057e474722f77848165f2893e0c76e21ae406415"
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  bottle do
    sha256 "044564e3cf60e137b105aaeea9cb82bfe687f3a33df9e6f76197016960b9b28d" => :catalina
    sha256 "b3d71ec2cb19c7b80a945c664824cde1b0b6756232b2b5a496e74fc2534e0f8b" => :mojave
    sha256 "f3f2b97e386374eccd8c21385491adf5cbfc1fe9f700ae910a72c4c5762fd770" => :high_sierra
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

  plist_options :startup => true

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
