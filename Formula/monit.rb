class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.28.1.tar.gz"
  sha256 "57d8885f66e58a0a4ca6a967f2bb7e8c15ed988a25b5ca6ba6733f919ef07a5c"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "504f884e120c6b7d869fde9dd4ba5eb0943c3fe7499c8518de1679463406d55c"
    sha256 cellar: :any,                 big_sur:       "66ac2b24dbad30f393b7ac51ae8f013f61acd4702ccd5c2f63cf4f343540926f"
    sha256 cellar: :any,                 catalina:      "7b43f0cfbb6632ddb61a2d218f219c790500d31de9586a0fc5cfb5181443c886"
    sha256 cellar: :any,                 mojave:        "50adb0351b6f9b01d63416620c901a9a766fefd3fd12cd38c56fe6c39a011237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81955bc8e3f29f808da2dce0e09b0a84b48e9970720500e5aea5512ff7c62e3a"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

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
