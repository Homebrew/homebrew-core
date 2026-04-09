class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.net/"
  # TODO: Check if extra `make` call can be removed at version bump.
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.11.0/getdata-0.11.0.tar.xz"
  sha256 "d16feae0907090047f5cc60ae0fb3500490e4d1889ae586e76b2d3a2e1c1b273"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bea9f976c185d2e9e5377cf772635f6e72a40380bda01cb5cbdb65e22a2a30bc"
    sha256 cellar: :any,                 arm64_sequoia: "c6dfdb5b0c484f44ba193dd52bed2f63d141d30930340fab2bbfc7a95256e4e9"
    sha256 cellar: :any,                 arm64_sonoma:  "ee816cb9530d8ea7c20cb12cb23fa9a1a39f9568532c8b7489452d9db84c803b"
    sha256 cellar: :any,                 sonoma:        "df59283bc4c705adf5fe040cd33a4a82f6e724a38f46907817a9f6f6f1064ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e8f70f87715450ab87a39327ea8dbef1dcf0e83c3e962dc59a4ee8e3a7ea2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71be7913ffccb6f8ba8a1cd425b2855046706c0ea14cd0607c1a3c0f295e01de"
  end

  depends_on "libtool"

  uses_from_macos "perl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-fortran",
                          "--disable-fortran95",
                          "--disable-php",
                          "--disable-python",
                          "--without-liblzma",
                          "--without-libzzip"

    ENV.deparallelize # can't open file: .libs/libgetdatabzip2-0.11.0.so (No such file or directory)
    system "make"
    # The Makefile seems to try to install things in the wrong order.
    # Remove this when the following PR is merged/resolved and lands in a release:
    # https://github.com/ketiltrout/getdata/pull/6
    system "make", "-C", "bindings/perl", "install-nodist_perlautogetdataSCRIPTS"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
