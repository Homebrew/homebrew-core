class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.2.1/minidlna-1.2.1.tar.gz"
  sha256 "67388ba23ab0c7033557a32084804f796aa2a796db7bb2b770fb76ac2a742eec"
  license "GPL-2.0-only"
  revision 6

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "0f008dfaac0220cdd26995d5f5fa00560328a6a30dd6d2ab8b78e23efd559337" => :catalina
    sha256 "befb568924df8d3b17095d864b84c11733b40e4860a7aecd65f1f4d19f9c343b" => :mojave
    sha256 "cfaad3159ef845f063cbe32262a59d98d0e0415f15d0ce41321993c2767972cf" => :high_sierra
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

  plist_options manual: "minidlna"

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

    port = free_port

    fork do
      exec "#{sbin}/minidlnad", "-d", "-f", "minidlna.conf", "-p", port.to_s, "-P", testpath/"minidlna.pid"
    end
    sleep 2

    assert_match /MiniDLNA #{version}/, shell_output("curl localhost:#{port}")
  end
end
