class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.3.3/minidlna-1.3.3.tar.gz"
  sha256 "39026c6d4a139b9180192d1c37225aa3376fdf4f1a74d7debbdbb693d996afa4"
  license "GPL-2.0-only"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "3b2a0c48265f03090c984a5cda3f33b5aefeb4971d929fd979436e994527a142"
    sha256 cellar: :any, arm64_sequoia: "6ec3fef5800203a454903f44e9076e1e41cd3e2382ae6b4727e4e5d9990833aa"
    sha256 cellar: :any, arm64_sonoma:  "3457530f1b8101109604864ed14dc1e2d27148df78f0f2ca1817ddbc799ab123"
    sha256 cellar: :any, sonoma:        "54c1e14b7dfed36b83b7baab7e4d7f338b43dacec2129e5ae50494f139d8a85f"
    sha256 cellar: :any, arm64_linux:   "c2dfb2a33179895d051aa64f7152f9be1b9b4a1a52846c2a42354b459aa0df5f"
    sha256 cellar: :any, x86_64_linux:  "7195f61a472be5dd8c0e7e6855761daecf3637e71c6da100fd8b7c88248964b2"
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
