class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.21.1.tar.gz"
  sha256 "1f6c084bdbf2686121f9b2f5e767275c1e37d9ccf67c8faabc762389f95a0c38"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d959fe3f680cc759bc8e6b5fc9ce3df87a0ba407fd8c121c7c0007b18a7391ed"
    sha256 arm64_sequoia: "d4b73f03f75990e67798f996eed66c02b42066d37c43c6970ed1345838ea6e3c"
    sha256 arm64_sonoma:  "c56bc527efd1a40a897de31f6f41876b6a4ca45ca6f642c2c1cfad52b92db9e2"
    sha256 sonoma:        "7bf3eb33efc70d4ef302c32eb64031d193004aee353d7d14c66afc69185eb90f"
    sha256 arm64_linux:   "b28520612f2942489d5fa1eb14051528d444558c63e3d04b4c14b028193577a3"
    sha256 x86_64_linux:  "037920375d831bc140fd1bb65563045b7105abdcf57f6d3882b2e0680df18140"
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

    on_arm do
      # FIXME: illegal instruction in test_simple_3_error_1 with Ubuntu GCC
      depends_on "gcc@12" => :build
    end
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
