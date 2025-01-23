class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.32.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.32.tar.xz"
  sha256 "4ddc83d1ede9af2363b3eab987f54b87cf6619324110ce2d3a0e70944d1359fe"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "ff5a4df237304db15c9c5b94e4f15814a18bb49e7f189dee446da7abc263a183"
    sha256 arm64_sonoma:  "7d3943764d79ff29e7382500ca321686f077d93123d31fc61c430066b3c4b198"
    sha256 arm64_ventura: "468bb2d2776bacef0dac42a73c69aa7d25157ca0aa933c468d491a47bf1f8a9f"
    sha256 sonoma:        "994b3d8cd142aa8750901f095d5cc4b1fcc1fde4a34ac002f68d0b33c735b31c"
    sha256 ventura:       "c93d522f8cba8bfed62da1feeaa6c8b18efbba6e8204e550f06e2ccc289cc049"
    sha256 x86_64_linux:  "03878d306fb02d438b384f28df3680991a789efb5f5fcb8f67063f938c23fcbc"
  end

  head do
    url "https://github.com/MidnightCommander/mc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "s-lang"

  on_macos do
    depends_on "diffutils"
    depends_on "gettext"
  end

  conflicts_with "minio-mc", because: "both install an `mc` binary"

  def install
    args = %w[
      --disable-silent-rules
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"

    if OS.mac?
      inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin"
      bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["diffutils"].opt_bin}:$PATH")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mc --version")
  end
end
