class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.16.2.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.16.2.orig.tar.xz"
  sha256 "0ba2a1a4b16afe7bceb2c07e9ce99a8c2c3508e5dec290dbb643384bd6beb7e2"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.freedesktop.org/dbus/dbus.git", branch: "main"

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "708eed3cc7031e486c760cc9debe777b7e8de93faf74320b66d3bc42e27499c3"
    sha256 arm64_sequoia: "5a51451acabb5ae56b5682e88a82dfa43cc6a2b653ca068198546bb72324bd0c"
    sha256 arm64_sonoma:  "1be729814991108cc593bb8472e376947898f8bf94b73271c2238c329514a3ba"
    sha256 arm64_ventura: "29098b5b3f154677a61c30b402b17fe2912e9efe1cd7917ee6ae754209fe1f29"
    sha256 sonoma:        "438a1da22c323246b958e0fbc63c5e7405dba77e9274809ebd73ab8c886a19d7"
    sha256 ventura:       "2f10ec74399e7ffb843022aa22bf11b088ab6b00d34da46d623fca78900f166b"
    sha256 arm64_linux:   "f636ed77fc07ab232ec75012b8b5a69cee10f8f239d48b1d5622baa83d9d9d7e"
    sha256 x86_64_linux:  "42841a5373f596cbccd52b4cf3eae4f3ec6a853309b14e36e869a7030fabd21a"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "expat"

  # Remove deprecated keys from launchd plist.
  # PR ref: https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/179
  patch :DATA

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      -Dlocalstatedir=#{var}
      -Dsysconfdir=#{etc}
      -Dxml_docs=enabled
      -Ddoxygen_docs=disabled
      -Dmodular_tests=disabled
    ]

    args << "-Dlaunchd_agent_dir=#{prefix}" << "-Ddbus_user=daemon" if OS.mac?
    inreplace "bus/org.freedesktop.dbus-session.plist.in", "@DBUS_DAEMONDIR@", opt_bin

    # rpath is not set for meson build
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Manually create plist for system bus service
    (prefix/"org.freedesktop.dbus-system.plist").write system_plist if OS.mac?
    mkdir etc/"dbus-1/system.d"
    mkdir etc/"dbus-1/session.d"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system bin/"dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  def caveats
    on_macos do
      <<~EOS
        To start the session bus now and at login:

          brew services start dbus

        To start the system bus now and on boot, install and activate the included daemon:

          sudo cp -f $(brew --prefix dbus)/org.freedesktop.dbus-system.plist /Library/LaunchDaemons
          sudo launchctl bootstrap system /Library/LaunchDaemons/org.freedesktop.dbus-system.plist

        If the daemon is already installed and running, restart it:

          sudo launchctl kickstart -k system/org.freedesktop.dbus-system
      EOS
    end
  end

  service do
    name macos: "org.freedesktop.dbus-session"
  end

  def system_plist
    <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>org.freedesktop.dbus-system</string>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/dbus-daemon</string>
          <string>--nofork</string>
          <string>--system</string>
          <string>--nopidfile</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>unix_domain_listener</key>
          <dict>
            <key>SockPathName</key>
            <string>#{var}/run/dbus/system_bus_socket</string>
            <key>SockPathMode</key>
            <integer>511</integer>
          </dict>
        </dict>
      </dict>
      </plist>
    PLIST
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbus-daemon --version")
  end
end

__END__
diff --git a/bus/org.freedesktop.dbus-session.plist.in b/bus/org.freedesktop.dbus-session.plist.in
index 40ff370..3c77fa9 100644
--- a/bus/org.freedesktop.dbus-session.plist.in
+++ b/bus/org.freedesktop.dbus-session.plist.in
@@ -5,15 +5,6 @@
 	<key>Label</key>
 	<string>org.freedesktop.dbus-session</string>
 
-	<key>ServiceIPC</key>
-	<true/>
-
-	<!-- Please uncomment on 10.4; OnDemand doesn't work properly there. -->
-	<!--
-	<key>OnDemand</key>
-	<false />
-	-->
-
 	<key>ProgramArguments</key>
 	<array>
 		<string>@DBUS_DAEMONDIR@/dbus-daemon</string>
