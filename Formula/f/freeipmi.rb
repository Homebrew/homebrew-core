class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/gnu/freeipmi/freeipmi-1.6.16.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.16.tar.gz"
  sha256 "5bcef6bb9eb680e49b4a3623579930ace7899f53925b2045fe9f91ad6904111d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "088038494ab5a3519fb61478cb8e5e70c82e267c4f05a718b2e7e59f93866dd1"
    sha256 arm64_sequoia: "59ef8ad0e134e1f8d63f7f363aa642af16d891998f0e88d7df3bbd9f5f5c5325"
    sha256 arm64_sonoma:  "a2a68d7e33c51537280537e68f20fa5f5f3daf472ed98a5c0b3ca7d1aa73e136"
    sha256 sonoma:        "bbab50242b9e092985c723e7e60f103a3237ea2124ac00df9b160a4f05d47e97"
    sha256 arm64_linux:   "17c67de9391aa8f42c54e1e99e14005940227b37a3ef466c98f81729db6b6827"
    sha256 x86_64_linux:  "f1b6706610f1b25cb10de66ab9963fdbe13d51e7bc2f7668fef2167649a2716a"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I. -I$(top_srcdir)/man $@.pre $@",
      "#{ENV.cxx} -E -nostdinc -w -C -P -I. -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
