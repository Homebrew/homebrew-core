class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2026.7.7.tgz"
  sha256 "d67b769025d32860549d35c2147e45024d172f81c540d750390ce3602c059dab"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  compatibility_version 1

  # GitHub release descriptions contain a link to the `stable` tarball.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "2250e32fd80e8f93821608aac9c319a5ef4acf4120baa540778a7c16e7719d7a"
    sha256 cellar: :any, x86_64_linux: "6697249707794af972c247fa4352a7d996ef9c0be1da11a6a2d8d5e8950e57d0"
  end

  head do
    url "https://github.com/tuxera/ntfs-3g.git", branch: "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libgcrypt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "coreutils" => :test
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    # Using upstream-maintained libfuse-lite similar to Debian and Fedora
    # until FUSE 3 is supported: https://github.com/tuxera/ntfs-3g/issues/54
    args = %W[
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=internal
      --enable-extras
      --disable-ldconfig
    ]

    system "./autogen.sh" if build.head?
    # Workaround for hardcoded /sbin
    inreplace Dir["{ntfsprogs,src}/Makefile.in"], "$(DESTDIR)/sbin/", "$(DESTDIR)#{sbin}/"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Install a script that can be used to enable automount
    File.open(sbin/"mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<~BASH
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
          -o auto_xattr \\
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
      BASH
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
