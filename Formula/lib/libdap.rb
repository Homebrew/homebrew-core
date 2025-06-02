class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.21.1.tar.gz"
  sha256 "1f6c084bdbf2686121f9b2f5e767275c1e37d9ccf67c8faabc762389f95a0c38"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1f8e9cd58ca9ef263b5a028262a32a1b06b8903cb2e7166446d25d60f7bbb5bd"
    sha256 arm64_sonoma:  "d8886f6fbec0a65ec3ed25dfd1bd13c7ac2f2a71c1b7674bd1b4897508477f8c"
    sha256 arm64_ventura: "3cef6f6506acf42d24cf9d0bf55b8b194ce5938d5d2d6d7e82a155c86e031a8a"
    sha256 sonoma:        "aecc5c17befb043a3cbf6939b0011190d4b4ebd8ecfe42748c67a0b35fc7e920"
    sha256 ventura:       "4b9be029b474845cfd29aedbf47548189fed0c2b977687c8778f5180b895a1b4"
    sha256 arm64_linux:   "bd0b6ca36a3f872a08c4401e9f1b24dbde3c08e2b97514d6175f7779815344ea"
    sha256 x86_64_linux:  "c0bbde3c7deb1480fe9d54028a7ce000692e28784c7e3b926d8c8234ff79c742"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libxml2"
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "libtirpc"
    depends_on "util-linux"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--with-included-regex", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Versions like `1.2.3-4` with a suffix appear as `1.2.3` in the output, so
    # we have to remove the suffix (if any) from the formula version to match.
    assert_match version.to_s.sub(/-\d+$/, ""), shell_output("#{bin}/dap-config --version")
  end
end
