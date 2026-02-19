class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.24.tar.gz"
  sha256 "a47b6c73f86e6421e86a883568dd08e299b20e36c11a99bdfbe50e01bde60e38"
  license "BSD-3-Clause-LBNL"

  # The homepage no longer links to a QD tarball and instead directs users to
  # the GitHub repository, so we check the Git tags.
  livecheck do
    url "https://github.com/BL-highprecision/QD.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3ca655810301b79586645117410defae98de1cd731c33980836abdb4d35d8515"
    sha256 cellar: :any,                 arm64_sequoia: "1cbee32662495e167dce863c774fdd9aa87c4ee3650da5da477daccdc685a46e"
    sha256 cellar: :any,                 arm64_sonoma:  "24301f8d2b3266a495fa80163ee64a56322d4445b42232c214fa2a58a8907644"
    sha256 cellar: :any,                 sonoma:        "62f94278c224f2b052894b132fb33bbf77ae1b12eb2c505416337cf66895b629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b10538c68aa7fb95aba6d7df372be107ff09d64451d8a55dcf224e6f01a722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdae75a75becb67577f375febf3594bbed031f7197252360234cc1509c6e14ef"
  end

  # Drop `autoconf`, `automake`, `libtool` when the patch is removed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran

  def install
    odie "check if autoreconf line can be removed" if version > "2.3.24"
    # regenerate since the files were generated using automake 1.16.5
    system "autoreconf", "--install", "--force", "--verbose"

    system "./configure", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
