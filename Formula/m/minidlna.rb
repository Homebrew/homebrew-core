class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.3/minidlna-1.3.3.tar.gz"
  sha256 "39026c6d4a139b9180192d1c37225aa3376fdf4f1a74d7debbdbb693d996afa4"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3a971dd6797fd9bc19c0473305861658dea94629092eeb4599f0820388b22b4"
    sha256 cellar: :any,                 arm64_sonoma:  "ec3048945b8e139ac5f5c5f155716e5e78b8a752ba539661148e1aac1d9c6e46"
    sha256 cellar: :any,                 arm64_ventura: "a0e8d265dd82a964d6e912a74e35b174eba83329466180ccc7b6fcce918c3f3b"
    sha256 cellar: :any,                 sonoma:        "359ca672fd75a717663eac68d270f1d855002404cc82dc7fe22ab72eedc70601"
    sha256 cellar: :any,                 ventura:       "c6e43a0397d8e87ddba11a2d75f8e656d6340af549c9e72132a327ca459dbef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fdde2237ecdca8be2b2d35b0ad861b17a7767b12b674530e56020f768af0ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b4e7f1931b7df49351bc9a5b982346ef79188ce57e7b3f977846664d1b942b"
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "ffmpeg@6" # ffmpeg 7 issue: https://sourceforge.net/p/minidlna/bugs/363/
  depends_on "flac"
  depends_on "gettext"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

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
