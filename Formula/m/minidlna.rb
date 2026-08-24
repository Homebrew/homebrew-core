class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.3/minidlna-1.3.3.tar.gz"
  sha256 "39026c6d4a139b9180192d1c37225aa3376fdf4f1a74d7debbdbb693d996afa4"
  license "GPL-2.0-only"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0653da91cd10baff42e22dc28994fe4886ed4bce3c4e4f9dbe726c5ff2487522"
    sha256 cellar: :any, arm64_sequoia: "b57474142d19a4bbb15397eb9e46c5e453c89612e3214f4d497e69070b1e423d"
    sha256 cellar: :any, arm64_sonoma:  "78110a01d94e4c5049b9dd74db05b9481657df38a32824bc78da4c73bfa0acfd"
    sha256 cellar: :any, sonoma:        "0f689a9ffd74e5f26e174cc600445048cb1316e6d82ccda352a603b849d9bf38"
    sha256 cellar: :any, arm64_linux:   "dcc32d273382b08b439ca5d6836e473a3a0108c89a7160ad9b190e1198a45232"
    sha256 cellar: :any, x86_64_linux:  "aed7febbcd7a0c0cf96cac14d1a6126c83e6a9e87360f11e96c208ae8c0a8a50"
  end

  head do
    url "https://git.code.sf.net/p/minidlna/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"

  on_macos do
    depends_on "gettext"
  end

  # Apply Fedora's patch to support newer FFmpeg; the upstream merge request is still open
  patch do
    url "https://src.fedoraproject.org/rpms/minidlna/raw/5de0e84859aa974c489b999ba75c83b5697eecb9/f/0001-Add-compatibility-with-FFMPEG-7.0.patch"
    sha256 "871833e6ae0dbf629b1ff3adc9a2e1c76f7e3ac9a07d0db29ad389847ce9fab4"
    type :unofficial
    resolves "https://sourceforge.net/p/minidlna/git/merge-requests/58/"
  end

  # Add missing include: https://sourceforge.net/p/minidlna/bugs/351/
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def caveats
    "To use `brew services`, put your configuration at ~/.config/minidlna/minidlna.conf"
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
