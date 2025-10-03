class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.6.2/dopewars-1.6.2.tar.gz"
  sha256 "623b9d1d4d576f8b1155150975308861c4ec23a78f9cc2b24913b022764eaae1"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "e8059b057bea2eb7a0c33542aebc0be5dfb26ba9f681594af77f6584accd328f"
    sha256 arm64_sequoia:  "5e19478fc233eac61d8c45e6b671f1853c0b4f95777a4a2d99ad1ed6eac6d38a"
    sha256 arm64_sonoma:   "8cb9bfd69260ceae6ce8a5062fcba8ee7aa4edcb7191dc048c0d03ca13a783aa"
    sha256 arm64_ventura:  "f6c44772360736b7f1aabbee2da0371fcef2435309a4a632d870e53af1e0729b"
    sha256 arm64_monterey: "076caa9d67e4e4f3fd0067ae16097631c0b0eaf6e243f9a78c48c70214b915f8"
    sha256 arm64_big_sur:  "2ebf3c275304427354f21de5426b2b9a1262ad60cb6e8d53b181114e2d56156a"
    sha256 sonoma:         "e6982cf7073199453e1aeca1fd7b0fa6ec852ad5162c45579baac9fec3d46a59"
    sha256 ventura:        "4f6d47cccb1c3ac186e1292963386355f28bd865f0d957275df20a9955266a8e"
    sha256 monterey:       "e321eb969358620d608a6021255cfc4f3a749779c2d307c09104d0f74e68613a"
    sha256 big_sur:        "32b55701ab1ec3a70bbd9b27b7fedca2e0cecf7e78877e39338c71b6eb810f3e"
    sha256 arm64_linux:    "bed017e7392dec34e43b0c79583de05fe42da19359046dbae1e5f8ea46144c38"
    sha256 x86_64_linux:   "7a543edc764a62a6b9c5e9884acb00b034e4631248f9c6b44e4c0cd8483f4e50"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    inreplace "src/Makefile.in", "$(dopewars_DEPENDENCIES)", ""
    inreplace "src/Makefile.in", "chmod", "true"
    inreplace "auxbuild/ltmain.sh", "need_relink=yes", "need_relink=no"
    inreplace "src/plugins/Makefile.in", "LIBADD =", "LIBADD = -module -avoid-version"

    system "./configure", "--disable-gui-client",
                          "--disable-gui-server",
                          "--enable-plugins",
                          "--enable-networking",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install", "chgrp=true"
  end

  test do
    system bin/"dopewars", "-v"
  end
end
