class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.3/minidlna-1.3.3.tar.gz"
  sha256 "39026c6d4a139b9180192d1c37225aa3376fdf4f1a74d7debbdbb693d996afa4"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cdc4271499e5b8b3e6c7effab75da360de272d956e592c74ceb272012cbedc2"
    sha256 cellar: :any,                 arm64_ventura:  "cfd00cc9d042aa7c6348edb85ccd3d46e961cf5db7889a983c3db86b7c426350"
    sha256 cellar: :any,                 arm64_monterey: "4ca9b45f96b3db7f8623ac80b17861b25091e851bd0d3b98ab018c2b70593797"
    sha256 cellar: :any,                 sonoma:         "0f9c174c508fe889e1e5849b43e779b360186fbc416303037379445fe0d713bd"
    sha256 cellar: :any,                 ventura:        "c4934d6d2fbc41afce5d1bf4a2f79b9fe9ffeef3dbf2c303c42e71db9bf27794"
    sha256 cellar: :any,                 monterey:       "321cde081415e6c35efe2c8522808c746578c3c5127f7a08df1bc3986c57ee4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257e53c6ef6bd70fc2369d097e0c7e0da5013dc8e9c763a0762ba5df0bc9588a"
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "ffmpeg@6"
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
