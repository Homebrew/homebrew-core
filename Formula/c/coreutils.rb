class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-9.8.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-9.8.tar.xz"
  sha256 "e6d4fd2d852c9141a1c2a18a13d146a0cd7e45195f72293a4e4c044ec6ccca15"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a05deb3349451dbbe11abd0b339a835f97a989f08345afb8c3a45952a0df6ee3"
    sha256 arm64_sequoia: "67c097eb1b01d8a5525c871e84260187d6308ae2965c013b0416bae62853c9dd"
    sha256 arm64_sonoma:  "fce6e52bd1afd5e8e91446f0def571ff4339bac5d866a1c77d1d392a2ea07a18"
    sha256 sonoma:        "69a6d4f328369ab2afc40032b6b44b68d765f308474cf6ad634fa1499ec38769"
    sha256 arm64_linux:   "1f948fa0dbd69feab36f771aada788c3a651486d8a5e9734b01094df55e0c634"
    sha256 x86_64_linux:  "d812e26edfa73bad913099488a6e6b86761c4275568592525d4e295142692af9"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  depends_on "gmp"
  uses_from_macos "gperf" => :build

  on_macos do
    conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"
  end

  on_sonoma :or_older do
    conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  end

  on_linux do
    depends_on "acl"
    depends_on "attr"
  end

  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "gfold", because: "both install `gfold` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"

  # https://github.com/Homebrew/homebrew-core/pull/36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  # Coreutils 9.8 had a bug in `tail` that made it seek to the wrong place in
  # files. Only update src/tail.c from the upstream commit otherwise `autoconf`
  # will be invoked.
  # https://github.com/coreutils/coreutils/commit/914972e80dbf82aac9ffe3ff1f67f1028e1a788b.patch?full_index=1
  patch :DATA

  def install
    ENV.runtime_cpu_detection
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --with-libgmp
      --without-selinux
    ]

    system "./configure", *args
    system "make", "install"

    no_conflict = if OS.mac?
      []
    else
      %w[
        b2sum base32 basenc chcon dir dircolors factor hostid md5sum nproc numfmt pinky ptx realpath runcon
        sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate vdir
      ]
    end

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd

      # Find non-conflicting commands on macOS
      which_cmd = which(cmd)
      no_conflict << cmd if OS.mac? && (which_cmd.nil? || !which_cmd.to_s.start_with?(%r{(/usr)?/s?bin}))
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
    (libexec/"gnubin").install_symlink "../gnuman" => "man"

    no_conflict -= breaks_macos_users if OS.mac?
    # Symlink non-conflicting binaries
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    msg = "Commands also provided by macOS and the commands #{breaks_macos_users.join(", ")}"
    on_linux do
      msg = "All commands"
    end
    <<~EOS
      #{msg} have been installed with the prefix "g".
      If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"gsha1sum", "-c", "test.sha1"
    system bin/"gln", "-f", "test", "test.sha1"
  end
end

__END__

diff --git a/src/tail.c b/src/tail.c
index b8bef1d91cdb6cde2b666b6c1575376e075eaeb8..c7779c77dfe4cf5a672a265b6e796c7153590170 100644
--- a/src/tail.c
+++ b/src/tail.c
@@ -596,7 +596,7 @@ file_lines (char const *prettyname, int fd, struct stat const *sb,
           goto free_buffer;
         }

-      pos = xlseek (fd, -bufsize, SEEK_CUR, prettyname);
+      pos = xlseek (fd, -(bufsize + bytes_read), SEEK_CUR, prettyname);
       bytes_read = read (fd, buffer, bufsize);
       if (bytes_read < 0)
         {
