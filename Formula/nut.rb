class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  revision 2

  stable do
    url "https://networkupstools.org/source/2.7/nut-2.7.4.tar.gz"
    sha256 "980e82918c52d364605c0703a5dcf01f74ad2ef06e3d365949e43b7d406d25a7"

    # Upstream fix for OpenSSL 1.1 compatibility
    # https://github.com/networkupstools/nut/pull/504
    patch do
      url "https://github.com/networkupstools/nut/commit/612c05ef.diff?full_index=1"
      sha256 "9d21e425eba72fbefba3c3d74465d239726798f95063c3b90b2e4b9a12414e12"
    end
  end

  bottle do
    sha256 "80c2ed8d7a3b3b56cf7d27ac2e3ce4c76d181ed234479dfb45ca8c997a6fbe63" => :catalina
    sha256 "4bad8169c9c0750fe3e537d9ad6efa961e7cd0882e133933d0bfcf906be46aeb" => :mojave
    sha256 "8c82af838412a2be677821aab3ec3f72f8e68bb997e7bcd42b828b5cf9b0dcc5" => :high_sierra
  end

  head do
    url "https://github.com/networkupstools/nut.git"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl@1.1"

  conflicts_with "rhino", :because => "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh"
    else
      # Regenerate configure, due to patch applied
      system "autoreconf", "-i"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}/nut",
                          "--with-statepath=#{var}/state/ups",
                          "--with-pidpath=#{var}/run",
                          "--with-macosx_ups",
                          "--with-openssl",
                          "--with-serial",
                          "--with-usb",
                          "--without-avahi",
                          "--without-cgi",
                          "--without-dev",
                          "--without-doc",
                          "--without-ipmi",
                          "--without-libltdl",
                          "--without-neon",
                          "--without-nss",
                          "--without-powerman",
                          "--without-snmp",
                          "--without-wrap"

    system "make", "install"
  end

  def post_install
    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  plist_options :manual => "upsmon -D"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/upsmon</string>
            <string>-D</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
