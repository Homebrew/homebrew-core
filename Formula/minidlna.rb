class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.2.1/minidlna-1.2.1.tar.gz"
  sha256 "67388ba23ab0c7033557a32084804f796aa2a796db7bb2b770fb76ac2a742eec"
  revision 1

  bottle do
    cellar :any
    sha256 "8018faef1d11436216b0c945ba682f52ee37ae437413371f788ff833f88f4334" => :catalina
    sha256 "e47addf7d21436e3b534b14024271d1d3355818f2e11a04da53a924f2acfe8e3" => :mojave
    sha256 "ed1b022aaea8beed91a26b9907c8253da9c5c441fa52482ae0255571cd1744ad" => :high_sierra
    sha256 "5145b3bae1ebb4add544bc8877668a5cea2e80a380a5a0beaba94a6e88cbf33c" => :sierra
    sha256 "16fb753050582f030bcc16de31ccac3faa74f5ada3d1bed4d17895dd8628f772" => :el_capitan
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (pkgshare/"minidlna.conf").write <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  def caveats
    <<~EOS
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{opt_pkgshare}/minidlna.conf ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  plist_options :manual => "minidlna"

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
            <string>#{opt_sbin}/minidlnad</string>
            <string>-d</string>
            <string>-f</string>
            <string>#{ENV["HOME"]}/.config/minidlna/minidlna.conf</string>
            <string>-P</string>
            <string>#{ENV["HOME"]}/.config/minidlna/minidlna.pid</string>
          </array>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/minidlnad.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/minidlnad.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/".config/minidlna/media").mkpath
    (testpath/".config/minidlna/cache").mkpath
    (testpath/"minidlna.conf").write <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{testpath}/.config/minidlna/media
      db_dir=#{testpath}/.config/minidlna/cache
      log_dir=#{testpath}/.config/minidlna
    EOS

    system sbin/"minidlnad", "-f", "minidlna.conf", "-p", "8081", "-P",
                             testpath/"minidlna.pid"
    sleep 2

    begin
      assert_match /MiniDLNA #{version}/, shell_output("curl localhost:8081")
    ensure
      Process.kill("SIGINT", File.read("minidlna.pid").to_i)
    end
  end
end
