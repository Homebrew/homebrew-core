class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.16.4.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.16.4.orig.tar.xz"
  sha256 "d08b05526c2cb7966a5fb79210d6112b1aca3d135f315c1b302e14b4b0297dac"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/dbus/dbus.git", branch: "main"

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "9f8972653845f2bfa57068ec941f0b036587e5d2f1d8415909899759fada1dae"
    sha256 arm64_tahoe:       "3d1593d9f05133c8e58571cc3270a5a1ede8c6d977c1bc3fe10516514a021acd"
    sha256 arm64_sequoia:     "cb4cb9ffcc60f6dbc1631df589c4d37c9d8db68c6def04d547963e8979d8aefc"
    sha256 arm64_linux:       "2461579d34d6fc487215889602d3f14a1466e1f84b1c6a8a2f78424173d5c23e"
    sha256 x86_64_linux:      "e41521843753f3185efa28311acf0bac57ee06341cb3bb51fbc22bcfee739404"
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

  post_install_steps do
    run "dbus-uuidgen", args: ["--ensure={{var}}/lib/dbus/machine-id"], base: :bin
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
