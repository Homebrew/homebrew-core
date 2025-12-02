class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.3/minidlna-1.3.3.tar.gz"
  sha256 "39026c6d4a139b9180192d1c37225aa3376fdf4f1a74d7debbdbb693d996afa4"
  license "GPL-2.0-only"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9fc0ed3ac5675b3dbfe74a361c9b43f7d82a29a65a12abc56ac1b9efd30d1258"
    sha256 cellar: :any,                 arm64_sequoia: "f7e718095ef9388cd38793641bcc399107f037cbf6bc744705ce58a5deb9c291"
    sha256 cellar: :any,                 arm64_sonoma:  "a848bf8fdcace687463088fbbbb1095d0259bd65de13e580f76c05673bf31cc3"
    sha256 cellar: :any,                 arm64_ventura: "014e64f8d81857532e0a65c2aaf361d18090fe2ff791ef351ea02311ccd69410"
    sha256 cellar: :any,                 sonoma:        "ff6b2f6bd3fcad653e0db52c02c40db6edb23d7bfbeb9647ed13c97e7607a9d1"
    sha256 cellar: :any,                 ventura:       "a95db24b987a5f9139174ccffbb740b561dca9218a2f683b89aeff6ce5156985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6c7d8e54a0dda78af8f46d94643bcbd11914bf8e6b20b534d4470127e4d492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12eec6b926c5633f8fd7565e772a4e334f2f61fa0ab9dfd3a2dfd654e594c997"
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
  depends_on "gettext"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  # Apply Fedora's patch to support newer FFmpeg. This has an open merge request:
  # https://sourceforge.net/p/minidlna/git/merge-requests/58/
  patch do
    url "https://src.fedoraproject.org/rpms/minidlna/raw/5de0e84859aa974c489b999ba75c83b5697eecb9/f/0001-Add-compatibility-with-FFMPEG-7.0.patch"
    sha256 "871833e6ae0dbf629b1ff3adc9a2e1c76f7e3ac9a07d0db29ad389847ce9fab4"
  end

  # Add missing include: https://sourceforge.net/p/minidlna/bugs/351/
  patch :DATA

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

    (pkgshare/"minidlna.conf").write conf unless (pkgshare/"minidlna.conf").exist?
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
    timeout = if Hardware::CPU.arm?
      30
    else
      50
    end
    io.expect("debug: Initial file scan completed", timeout)
    assert_path_exists testpath/"minidlna.pid"

    # change back to localhost once https://sourceforge.net/p/minidlna/bugs/346/ is addressed
    assert_match "MiniDLNA #{version}", shell_output("curl 127.0.0.1:#{port}")
  end
end

__END__
diff --git a/kqueue.c b/kqueue.c
index 35b3f2b..cf425cf 100644
--- a/kqueue.c
+++ b/kqueue.c
@@ -28,6 +28,7 @@

 #include <sys/types.h>
 #include <sys/event.h>
+#include <sys/time.h>
 #include <assert.h>
 #include <errno.h>
 #include <stdlib.h>
