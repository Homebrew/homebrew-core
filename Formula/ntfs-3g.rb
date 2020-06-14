class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  revision 3
  stable do
    url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2017.3.23.tgz"
    sha256 "3e5a021d7b761261836dcb305370af299793eedbded731df3d6943802e1262d5"

    # Fails to build on Xcode 9+. Fixed upstream in a0bc659c7ff0205cfa2b2fc3429ee4d944e1bcc3
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3933b61bbae505fa95a24f8d7681a9c5fa26dbc2/ntfs-3g/lowntfs-3g.c.patch"
      sha256 "749653cfdfe128b9499f02625e893c710e2167eb93e7b117e33cfa468659f697"
    end
  end

  bottle do
    cellar :any
    sha256 "d336f9c7dbdcba28ed416704db13091db3494769f598b38b027022846aa77cdd" => :catalina
    sha256 "67179cbc357c2d28304851f0abe3f42a0c6171200e79888a20ba732309ec84c9" => :mojave
    sha256 "f26c2db849a54951a5daddbdecc779ca9a2ef4b066a1fe2dda134ea34436d32b" => :high_sierra
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
  depends_on "coreutils" => :test
  depends_on "gettext"
  depends_on :osxfuse

  def install
    ENV.append "LDFLAGS", "-lintl"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=external
      --enable-extra
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

        if [ "$(/usr/bin/stat -f %u /dev/console)" -ne 0 ]; then
          USER_ID=$(/usr/bin/stat -f %u /dev/console)
          GROUP_ID=$(/usr/bin/stat -f %g /dev/console)
        fi

        #{opt_bin}/ntfs-3g \\
          -o volname="${VOLUME_NAME}" \\
          -o local \\
          -o negative_vncache \\
          -o auto_cache \\
          -o noatime \\
          -o windows_names \\
          -o streams_interface=openxattr \\
          -o inherit \\
          -o uid="$USER_ID" \\
          -o gid="$GROUP_ID" \\
          -o allow_other \\
          -o big_writes \\
          "$@" >> /var/log/mount-ntfs-3g.log 2>&1

        exit $?;
      EOS
    end
  end

  test do
    # create a small raw image, format and check it
    ntfs_raw = testpath/"ntfs.raw"
    system Formula["coreutils"].libexec/"gnubin/truncate", "--size=10M", ntfs_raw
    ntfs_label_input = "Homebrew"
    system sbin/"mkntfs", "--force", "--fast", "--label", ntfs_label_input, ntfs_raw
    system bin/"ntfsfix", "--no-action", ntfs_raw
    ntfs_label_output = shell_output("#{sbin}/ntfslabel #{ntfs_raw}")
    assert_match ntfs_label_input, ntfs_label_output
  end
end
