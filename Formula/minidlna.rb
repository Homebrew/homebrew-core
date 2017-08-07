class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.2.0/minidlna-1.2.0.tar.gz"
  sha256 "8d34436580c4c44be25976d5e46bc5b71af69bf441c4492774eac001164c4433"
  revision 1

  bottle do
    cellar :any
    sha256 "6caa52d90cb785abfaab9f7b693924b184ba7d0e226ac722b32cde5bae378fbf" => :sierra
    sha256 "527e7622ff531aab9cecd253499d81ec3ea976c527fbe45db36fc513b39ddf23" => :el_capitan
    sha256 "d94820c5a1bae266d7e6572044f9f07f0484d97ca37cfc8c5cd2cc05933056dc" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (pkgshare/"minidlna.conf").write <<-EOS.undent
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  def caveats; <<-EOS.undent
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{opt_pkgshare}/minidlna.conf ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  plist_options :manual => "minidlna"

  def plist; <<-EOS.undent
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
    (testpath/"minidlna.conf").write <<-EOS.undent
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
