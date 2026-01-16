class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-2.0.3.tar.gz"
  sha256 "53b0f4bc49369f06195e9e13abb6cff352d5acb79e861004ec95973896488cf4"
  license "0BSD"

  livecheck do
    url :homepage
    regex(/href=["']?passwdqc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "955ce4031458fb9914907717011bc5b7093d4dd9623de3ce11646e3630444745"
    sha256 cellar: :any,                 arm64_sequoia:  "ff2e3463c33e26713d8d994134dbcf4cc3b90f2eae60135ef52821ec82af6dc9"
    sha256 cellar: :any,                 arm64_sonoma:   "8c8d9e924950156472e0040224cf7f30a6e6c256eccc027746be8a9211b245f4"
    sha256 cellar: :any,                 arm64_ventura:  "d6212417a711c18e45a28eb3a24a775d091665538ed50f678d077fa47e647f7d"
    sha256 cellar: :any,                 arm64_monterey: "1fa6444ca8237d6bed9e187245dee44ea797f13c8822ab77527df7c47f324c16"
    sha256 cellar: :any,                 arm64_big_sur:  "e8d4dc476b0ff113653823c425dcbfc89ad57112a89086fa8602f27f0c3c0f41"
    sha256 cellar: :any,                 sonoma:         "c5f29e9353bb3887d132a98468ffb9f01d7058d22a95bb062e6e63e8d2c345a1"
    sha256 cellar: :any,                 ventura:        "40dd6c923246ef225bf9e129e5ae142ed77fe7d111f92654fab0e3edd921f612"
    sha256 cellar: :any,                 monterey:       "72f01dbc795a98ac1ec65db7c31f62e13182d47c422b116c57f72d34a8fc7c6f"
    sha256 cellar: :any,                 big_sur:        "7fb7c879feb5562187e03d4d2a1bbc5be855330c1382cac43ef3378818eacb02"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4bf9371aae5b2908b63aba467004476df6255d29a3f84e0c4a06872084857398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef0b2b3f545ca92181f77b7fff78992ffe1a6a84d31dd26103ecc3696cb9a3f"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    # https://github.com/openwall/passwdqc/issues/15
    inreplace "passwdqc_filter.h", "<endian.h>", "<machine/endian.h>" if OS.mac?

    args = %W[
      BINDIR=#{bin}
      CC=#{ENV.cc}
      CONFDIR=#{etc}
      DEVEL_LIBDIR=#{lib}
      INCLUDEDIR=#{include}
      MANDIR=#{man}
      PREFIX=#{prefix}
      SHARED_LIBDIR=#{lib}
    ]

    args << if OS.mac?
      "SECUREDIR_DARWIN=#{prefix}/pam"
    else
      "SECUREDIR=#{prefix}/pam"
    end

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args << "CFLAGS=#{ENV.cflags}" if ENV.cflags.present?

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
