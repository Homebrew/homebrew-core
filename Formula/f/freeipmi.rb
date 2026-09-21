class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.19.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.19.tar.gz"
  sha256 "f95c2b73797c4a0341a42a7b3c43efb60954c4130d082ad348fd40da554b4e85"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "2f85acaa63ee7fe156a9258cecfe2216cda2511f1dd45bdd51d2dc17482bc40f"
    sha256 arm64_tahoe:       "933c32ff1ce9a270259b70e1f49bd43347b2f9d894713bc1fdcc4a6cc615c8ff"
    sha256 arm64_sequoia:     "79aed80d0d1b688cd4effaa75f0a89baeb1c4e61df03e013c5c32cdb46ebf6e5"
    sha256 arm64_sonoma:      "76a7ea8b1afc71d05a05f995b05d4e5cc6278cb69fb0c54f57c613a8f1c63cf1"
    sha256 arm64_linux:       "7b98158e64e707986ae12a48d437c1d89f3087643317be3ea2843973581afc44"
    sha256 x86_64_linux:      "1cf03b917ca8176822313b094af2f231ff4ab214e04bcb17ff8097991ab39e72"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in", "$(CPP_FOR_BUILD)", "#{ENV.cxx} -E"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
