class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.27.2.tar.gz"
  sha256 "d8809c78d5dc1ed7a7ba32a5a55c5114855132cc4da4805f8d3aaf8cf46eaa4c"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "604ca8a7fc489944c10ba977e347e8f32d1047eba3df964d2bc110688abf6c50" => :big_sur
    sha256 "773afd93ee38969dc419d15268722ff26b00b4c757357a13a1db126a979f0ad8" => :arm64_big_sur
    sha256 "a32c42c13cbdec8feb567fdfc6c11713804335f5a5bc39215d188672f0b584cc" => :catalina
    sha256 "1b4d05159e7bc6101ff3f5cbb84f67ee941553927c23fc59780d84a4ed0d9023" => :mojave
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  plist_options manual: "monit -I -c #{HOMEBREW_PREFIX}/etc/monitrc"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>              <string>#{plist_name}</string>
          <key>ProcessType</key>        <string>Adaptive</string>
          <key>Disabled</key>           <false/>
          <key>RunAtLoad</key>          <true/>
          <key>LaunchOnlyOnce</key>     <false/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/monit</string>
            <string>-I</string>
            <string>-c</string>
            <string>#{etc}/monitrc</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
