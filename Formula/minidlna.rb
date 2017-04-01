class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.5/minidlna-1.1.5.tar.gz"
  sha256 "8477ad0416bb2af5cd8da6dde6c07ffe1a413492b7fe40a362bc8587be15ab9b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5eadd2ce885299d36c2f1c6dc50e34a2f54ff18b6a76340e7859d35f26122345" => :sierra
    sha256 "333bbc7986eefd5978982ad1b7c72c5a4ff2c22be9b0af9357f7629b56e6bbdb" => :el_capitan
    sha256 "310c94efdbe5776636689b1c0d49f8a4d67c542d6a47c4426a01561bd85ca605" => :yosemite
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
    ENV.append_to_cflags "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--exec-prefix=#{prefix}"
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

    pid = fork do
      exec "#{sbin}/minidlnad -f minidlna.conf -p 8081 -P #{testpath}/minidlna.pid"
    end
    sleep 2

    begin
      assert_match /MiniDLNA #{version}/, shell_output("curl localhost:8081")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
