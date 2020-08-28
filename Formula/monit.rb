class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.27.0.tar.gz"
  sha256 "d8c0deef624f193a952502fe9baabfa66e3d8d057df5738da43f9a37792afca4"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "244bbb87c88f90a08e157cf9fb50e501d15369a1c79cf66badb766bdd8de6fbb" => :catalina
    sha256 "dfe692f5f8a4320956f237dd920d59a06801c8e89dfcca6aba01a2e2f9a0bbab" => :mojave
    sha256 "7548c14639efa1102971eaf6f1d61dd32e4a6384afe2cfb70e20333979aa7338" => :high_sierra
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
