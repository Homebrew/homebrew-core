class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.0/minidlna-1.3.0.tar.gz"
  sha256 "47d9b06b4c48801a4c1112ec23d24782728b5495e95ec2195bbe5c81bc2d3c63"
  license "GPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c7913138763b5a466470cbda993c72da2236e6286badc45728c48084d2e4e0e"
    sha256 cellar: :any,                 arm64_big_sur:  "76ca2bb23a966e93b39f28b3d2ef5fc19cca8f1074f31cdc9f4c7caf562a3c75"
    sha256 cellar: :any,                 monterey:       "5159e029a8b9885ad2892119974690ee7f0a8ca21b83c16839e5241596c5a0f5"
    sha256 cellar: :any,                 big_sur:        "85ea96fe99907a4ff774fb7c1e922a7ab5ce32acd6d675a1ffeec8c27ad004e1"
    sha256 cellar: :any,                 catalina:       "9dc72f2c444380754e6d2491a91c8cc7bdc23dd752ffa688799f7fdfb14687e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9473c427835d028710a76203143d114b22b650cc6ca45e18e607c8ff20f9cc7c"
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def post_install
    conf = <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{Dir.home}/.config/minidlna/media
      db_dir=#{Dir.home}/.config/minidlna/cache
      log_dir=#{Dir.home}/.config/minidlna
    EOS

    (pkgshare/"minidlna.conf").write conf unless File.exist? pkgshare/"minidlna.conf"
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

  service do
    run [opt_sbin/"minidlnad", "-d", "-f", "#{Dir.home}/.config/minidlna/minidlna.conf",
         "-P", "#{Dir.home}/.config/minidlna/minidlna.pid"]
    keep_alive true
    log_path var/"log/minidlnad.log"
    error_log_path var/"log/minidlnad.log"
  end

  test do
    require "expect"

    (testpath/".config/minidlna/media").mkpath
    (testpath/".config/minidlna/cache").mkpath
    (testpath/"minidlna.conf").write <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{testpath}/.config/minidlna/media
      db_dir=#{testpath}/.config/minidlna/cache
      log_dir=#{testpath}/.config/minidlna
    EOS

    port = free_port

    io = IO.popen("#{sbin}/minidlnad -d -f minidlna.conf -p #{port} -P #{testpath}/minidlna.pid", "r")
    io.expect("debug: Initial file scan completed", 30)
    assert_predicate testpath/"minidlna.pid", :exist?

    assert_match "MiniDLNA #{version}", shell_output("curl localhost:#{port}")
  end
end
