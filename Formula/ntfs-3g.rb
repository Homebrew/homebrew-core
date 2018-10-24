class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2017.3.23.tgz"
  sha256 "3e5a021d7b761261836dcb305370af299793eedbded731df3d6943802e1262d5"

  bottle do
    sha256 "7fca129fd960c9b8ea4459232ddbd7041b427825feb724903775b386000fb5ad" => :mojave
    sha256 "f5fdf264ba84f10204564e7e33bac6cb2e657052bbf141ca735682f9d7842003" => :high_sierra
    sha256 "66662baf5f187c4784ff9c4236d9595205c01c6c7141699b8afcdb4337304a0c" => :sierra
    sha256 "dc2dc22afe3376cccb2a7d62f3faf4455a2422ebe4c96eaebd6d9249a00e3c2d" => :el_capitan
    sha256 "160fd2811b0fe6e072194860e17e2abbe71b18a2ac2c16db15ceb2eaf1e9918a" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/ntfs-3g/ntfs-3g.git",
        :branch => "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libgcrypt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on :osxfuse

  # Detection of struct stat members fails Xcode 9
  # Reported by email on 2017-09-19
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e0b6faaa0d/ntfs-3g/10.13.patch"
      sha256 "7550061c6ad7fd99e7c004d437a66af54af983acb9839e098156480106cd7a92"
    end
  end

  def install
    ENV.append "LDFLAGS", "-lintl"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=external
    ]

    system "./autogen.sh" if build.head?
    # Workaround for hardcoded /sbin in ntfsprogs
    inreplace "ntfsprogs/Makefile.in", "/sbin", sbin
    system "./configure", *args
    system "make"
    system "make", "install"

    # Install a script that can be used to enable automount
    File.open("#{sbin}/mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<~EOS
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

  test do
    output = shell_output("#{bin}/ntfs-3g --version 2>&1")
    assert_match version.to_s, output
  end
end
