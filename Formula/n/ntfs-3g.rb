class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  # tuxera.com returns 403 to CI runners, so use the GitHub tag tarball instead
  url "https://github.com/tuxera/ntfs-3g/archive/refs/tags/2026.11.23.tar.gz"
  sha256 "fa72b202a4ee509436e722172e7a94d12ab917fb4cacf2b4994fd45be2ea5cb8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  compatibility_version 3
  head "https://github.com/tuxera/ntfs-3g.git", branch: "edge"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5c7f318801a9d85a5a7b89df3d2e2a1549c765c3eaa1145d1a5237419b2abe15"
    sha256 cellar: :any, arm64_linux:  "541475276ab67431c77f311c08a0a0615d91e9d71f2a8c3cdae064cdce686b89"
    sha256 cellar: :any, x86_64_linux: "160152ffd63b747ab4e9152e2192da0ab55fc6e8106be84cbe4e56a4d9486499"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libgcrypt" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "coreutils" => :test
  depends_on :linux # on macOS, requires closed-source macFUSE

  deny_network_access!

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

    system "./autogen.sh"
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
    system formula_opt_libexec("coreutils")/"gnubin/truncate", "--size=10M", ntfs_raw
    ntfs_label_input = "Homebrew"
    system sbin/"mkntfs", "--force", "--fast", "--label", ntfs_label_input, ntfs_raw
    system bin/"ntfsfix", "--no-action", ntfs_raw
    ntfs_label_output = shell_output("#{sbin}/ntfslabel #{ntfs_raw}")
    assert_match ntfs_label_input, ntfs_label_output
  end
end
