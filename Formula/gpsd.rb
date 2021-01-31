class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.22.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.22.tar.xz"
  sha256 "68d2a04e237a02ce42158ceda462a24afe11eeaa2b13482e94ac7ef66693f3a0"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a68031d9cbef4b9cfbdfed566b8d0e556ae8188cedd6f505ca65314588bbc7f4" => :big_sur
    sha256 "94c0f86ec9ec850c0fd8f8b3069e6881dd895e57324c5eb46822406441208317" => :arm64_big_sur
    sha256 "e41f44df2cf96b33b2f62e65ff2ef9154d872bc8fac88b3bdaeb503246d77c2b" => :catalina
    sha256 "caafc4aea3632fdbe8df1ce265c025430a816d2ad7c26f973c254887ec6a2a8f" => :mojave
    sha256 "bc0775e450c0129fd71a4abd163a7645ac9b3e1698009b2735fafeb838e09e79" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "docbook" => :build
  depends_on "python@3.9" => :build
  depends_on "scons" => :build
  depends_on "xmlto" => :build

  uses_from_macos "ncurses"

  resource "gps" do
    url "https://files.pythonhosted.org/packages/35/73/958b3163573839d7f83cc84199ac1ce7068c3c39dca548fdfa5d37b93392/gps-3.19.tar.gz"
    sha256 "9e1d2280e4944ddb46cf19772b2768848db91bf8363ad8a72b7996b1c6dd560a"
  end

  # patch to skip-validation for xmlto doc generation
  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    resource("gps").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
    end

    system "scons", "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    system "scons", "install"
  end

  def caveats
    <<~EOS
      gpsd does not automatically detect GPS device addresses. Once started, you
      need to force it to connect to your GPS:

        GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/gpsd -N -F #{HOMEBREW_PREFIX}/var/gpsd.sock /dev/tty.usbserial-XYZ"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/gpsd</string>
          <string>-N</string>
          <string>-F</string>
          <string>#{var}/gpsd.sock</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/gpsd.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/gpsd.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/gpsd -V")
  end
end

__END__
diff --git a/SConscript b/SConscript
index d0b0908..8430b63 100644
--- a/SConscript
+++ b/SConscript
@@ -1420,7 +1420,7 @@ if not cleaning and not helping:
             htmlbuilder = build % docbook_html_uri
             manbuilder = build % docbook_man_uri
         elif WhereIs("xmlto"):
-            xmlto = "xmlto -o `dirname $TARGET` %s $SOURCE"
+            xmlto = "xmlto --skip-validation -o `dirname $TARGET` %s $SOURCE"
             htmlbuilder = xmlto % "html-nochunks"
             manbuilder = xmlto % "man"
         else:
