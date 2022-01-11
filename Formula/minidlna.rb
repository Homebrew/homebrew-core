class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.0/minidlna-1.3.0.tar.gz"
  sha256 "47d9b06b4c48801a4c1112ec23d24782728b5495e95ec2195bbe5c81bc2d3c63"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db29d32f52db2f939303ebfe9fadc4198cbf124b3eaea49708d862910dd397c9"
    sha256 cellar: :any,                 arm64_big_sur:  "d35c538a159b100120b6adb5f61c659fdf2a9d0e436abd089cc27a88f3e874ed"
    sha256 cellar: :any,                 monterey:       "e08ad5a4607e1b18dc9102fff5a18609e6288b28ef466e59064a15386fd0a3ef"
    sha256 cellar: :any,                 big_sur:        "84ad29fbefad1de42626e8cee294439c48f9d517edb2600221943faae4b2263b"
    sha256 cellar: :any,                 catalina:       "96292e855293ce1fa5b3b24ad9d50d26deb183c572ce8020d60571337c014574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d09940a0842037febe0e1e4d08e0e810ede2462c2a6049f86c5346d8dab92d7"
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
    conf = <<~EOS
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
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
    run [opt_sbin/"minidlnad", "-d", "-f", "#{ENV["HOME"]}/.config/minidlna/minidlna.conf",
         "-P", "#{ENV["HOME"]}/.config/minidlna/minidlna.pid"]
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
