class Proxysql < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://www.proxysql.com/"
  url "https://github.com/sysown/proxysql/archive/v1.4.9.tar.gz"
  # mirror "https://tukaani.org/xz/xz-5.2.4.tar.gz"
  sha256 "28ee75735716ab2e882b377466f37f5836ce108cfcfe4cf36f31574f81cce401"

  # Build dependencies listed here: https://github.com/sysown/proxysql/blob/master/INSTALL.md
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "curl"
  depends_on "openssl"

  # https://github.com/sysown/proxysql/pull/1564
  # TODO when the 1.4.10 release is cut, this formula should be updated and
  # this patch should be removed.
  patch do
    url "https://github.com/sysown/proxysql/compare/v1.4.10...zbentley:v1.4.10.diff?full_index=1"
    sha256 "c0beccc67a834b5eb2b9d2d70ac28556eaf0268cc456453c97e326e68c894622"
  end

  # Fixed upstream, not yet released.
  # TODO when the 1.4.10 release is cut, this formula should be updated
  # and this patch should be removed.
  patch do
    url "https://github.com/sysown/proxysql/commit/9dab0eba12a717b738264d6928599034ea3ebe81.diff?full_index=1"
  end

  def install
    system "make"
    # There's a 'make install' target, but since the installer does not have a
    # configurable prefix, it writes outside of brew-managed directories. All
    # it does is copy files, so rather than inreplace-ing the makefile, just
    # do the install manually. Given the way the rest of the Proxysql build
    # system works, this doesn't seem likely to change any time soon.
    # See https://github.com/sysown/proxysql/blob/master/Makefile
    bin.install "src/proxysql"
    etc.install "etc/proxysql.cnf"
  end

  test do
    system bin/"proxysql", "--help"
  end
end
