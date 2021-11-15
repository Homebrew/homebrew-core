class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https://www.tuxera.com/community/open-source-ntfs-3g/"
  url "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2021.8.22.tgz"
  sha256 "55b883aa05d94b2ec746ef3966cb41e66bed6db99f22ddd41d1b8b94bb202efb"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ec7322145e67988020b06ac47004aadc9cc1ffdfea213d82b787ebbb44bfaef"
  end

  head do
    url "https://github.com/tuxera/ntfs-3g.git", branch: "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libgcrypt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "coreutils" => :test
  depends_on "gettext"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    args = std_configure_args + %W[
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=external
      --enable-extras
      --disable-ldconfig
    ]

    system "./autogen.sh" if build.head?
    # Workaround for hardcoded /sbin
    inreplace Dir["{ntfsprogs,src}/Makefile.in"], "$(DESTDIR)/sbin/", "$(DESTDIR)#{sbin}/"
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
      EOS
    end
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
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
