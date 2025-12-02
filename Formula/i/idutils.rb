class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/software/idutils/"
  url "https://ftpmirror.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?idutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "e60e746f4261098cdd11898d89c236538d8232579351a5ebad27194c7f3f3784"
    sha256 arm64_sequoia:  "63d48bcd08d23874fff1f37a66c022c47c10c085549405f4fa8cdb4ba8d34b28"
    sha256 arm64_sonoma:   "cfeadacc331e01cf64d880d4f9b35a54870ea30594d638b58f245f4cda394469"
    sha256 arm64_ventura:  "c410f473b777ac344a863267348be1dc14f587c28f6c3a5845cc556ce52ba843"
    sha256 arm64_monterey: "072b4846a5c749954544e7b747d2951d4ee43a4bd6f024e817ac74743cdeefa7"
    sha256 arm64_big_sur:  "321fd582b7e17f7f912f76f0b5e8f57d16ebf9ea6c8721854c2567df8136fe28"
    sha256 sonoma:         "3107240f1d74fde8a91d009fadbdbd2a3e2e0384476735365c9d87a919421d2c"
    sha256 ventura:        "1d29ee25c018fa81e5cc297091cb8190fa0dbdb54c2ad21c8909cff989e8703c"
    sha256 monterey:       "e3fc421fedb08ac46a82fb2dd8127f4c7c03c6103d943b53a49e8220406ed157"
    sha256 big_sur:        "4e20dbb5fa6efb604aba5c3fab7b2fe948517c16569a3c27fa5b314e0d0730bf"
    sha256 catalina:       "7e27c7bad2b5d30c4ee26ffb21cf0412706e83c17d0d55b7cefd1f63c919063c"
    sha256 arm64_linux:    "a82f5ffc54658cb4994b62c8db6217395eb90e9b863b2b4de410ef267db66ce9"
    sha256 x86_64_linux:   "54a8af17aba2695b61bd976d6ae4bf2f13c45cec787b1c14b497080d5bac9ce9"
  end

  conflicts_with "coreutils", because: "both install `gid` and `gid.1`"

  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  # Fix build on Linux. Upstream issue:
  # https://savannah.gnu.org/bugs/?57429
  # Patch submitted here:
  # https://savannah.gnu.org/patch/index.php?10240
  patch :DATA

  def install
    args = ["--disable-silent-rules", "--with-lispdir=#{elisp}"]
    if OS.linux?
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      # Workaround to use outdated gnulib with glibc 2.28+ based on gnulib fix[^1].
      # Upstream updated to newer gnulib[^2] which should fix issue in next release.
      #
      # [^1]: https://github.com/coreutils/gnulib/commit/4af4a4a71827c0bc5e0ec67af23edef4f15cee8e
      # [^2]: https://git.savannah.gnu.org/cgit/idutils.git/commit/?id=6efa403e105381a468d8b2cb8c254c1c217d1b53
      ENV.append_to_cflags "-D_IO_ftrylockfile -D_IO_IN_BACKUP=0x100"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    usr = if OS.mac?
      "#{MacOS.sdk_path_if_needed}/usr"
    else
      "/usr"
    end
    system bin/"mkid", "#{usr}/include"

    system bin/"lid", "FILE"
  end
end

__END__
diff --git a/lib/stdio.in.h b/lib/stdio.in.h
index 0481930..79720e0 100644
--- a/lib/stdio.in.h
+++ b/lib/stdio.in.h
@@ -715,7 +715,6 @@ _GL_CXXALIASWARN (gets);
 /* It is very rare that the developer ever has full control of stdin,
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
-_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
 #endif
