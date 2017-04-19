class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2016.2.22.tgz"
  sha256 "d7b72c05e4b3493e6095be789a760c9f5f2b141812d5b885f3190c98802f1ea0"

  bottle do
    cellar :any
    sha256 "f0e372ea3442a6989afab7083fbdb381d65d14ad24bb0d2a2130983e3bc5fe7e" => :sierra
    sha256 "44324ff2bb03ebda1de9a593d59e24794156b555e81ad9f844aca90a3dbffd1d" => :el_capitan
    sha256 "bcefa6dcccb472e1fe09b7bb0eca306c5ee976f4658d5da35579e74736384ee5" => :yosemite
  end

  head do
    url "git://git.code.sf.net/p/ntfs-3g/ntfs-3g", :branch => "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libgcrypt" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on :osxfuse

  def install
    ENV.append "LDFLAGS", "-lintl"
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--exec-prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-fuse=external"]

    system "./autogen.sh" if build.head?
    inreplace "ntfsprogs/Makefile.in", "/sbin", sbin # Workaround for hardcoded /sbin in ntfsprogs
    system "./configure", *args
    system "make"
    system "make", "install"

    # Install a script that can be used to enable automount
    File.open("#{sbin}/mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<-EOS.undent
      #!/bin/bash

      VOLUME_NAME="${@:$#}"
      VOLUME_NAME=${VOLUME_NAME#/Volumes/}
      USER_ID=#{Process.uid}
      GROUP_ID=#{Process.gid}

      if [ `/usr/bin/stat -f %u /dev/console` -ne 0 ]; then
        USER_ID=`/usr/bin/stat -f %u /dev/console`
        GROUP_ID=`/usr/bin/stat -f %g /dev/console`
      fi

      #{opt_bin}/ntfs-3g \\
        -o volname="${VOLUME_NAME}" \\
        -o local \\
        -o negative_vncache \\
        -o auto_xattr \\
        -o auto_cache \\
        -o noatime \\
        -o windows_names \\
        -o user_xattr \\
        -o inherit \\
        -o uid=$USER_ID \\
        -o gid=$GROUP_ID \\
        -o allow_other \\
        "$@" >> /var/log/mount-ntfs-3g.log 2>&1

      exit $?;
      EOS
    end
  end
end
