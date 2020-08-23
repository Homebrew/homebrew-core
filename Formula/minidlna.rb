class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.2.1/minidlna-1.2.1.tar.gz"
  sha256 "67388ba23ab0c7033557a32084804f796aa2a796db7bb2b770fb76ac2a742eec"
  revision 3

  bottle do
    cellar :any
    sha256 "200ede8d7a76a0ddf22978ec19f464e7716ae1e33c0c01b17877de7fcf0a0ea9" => :catalina
    sha256 "c8b56b111f9625c1baaf66e9f06f6e7df6b039e1ebb188995edb16c2e264830c" => :mojave
    sha256 "09e2127980deb0e8ed824e72bfa575f110b737ed4fa653ef0edb629faa815369" => :high_sierra
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

    system sbin/"minidlnad", "-f", "minidlna.conf", "-p", port.to_s, "-P",
                             testpath/"minidlna.pid"
    sleep 2

    assert_match /MiniDLNA #{version}/, shell_output("curl localhost:#{port}")
  end
end
