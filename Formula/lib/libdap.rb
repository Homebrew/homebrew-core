class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    # TODO: Update deps and `install` method when libtirpc patch on Linux is no longer needed.
    url "https://www.opendap.org/pub/source/libdap-3.20.11.tar.gz"
    sha256 "850debf6ee6991350bf31051308093bee35ddd2121e4002be7e130a319de1415"

    # Fix flat namespace flag on Big Sur+.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c8a5f36b1d1599554e7523671dc192a2d0a444a8e2fcc0e73ca92a66af9843ed"
    sha256 arm64_ventura:  "c4655809997b644c2a9e628bf405a85b33681231830c5a08fee719ebc2794b09"
    sha256 arm64_monterey: "2a0cac8b856a1780abaabbf46b0de39682bb192eb3888ccf7e12eab1c2ffa8f0"
    sha256 arm64_big_sur:  "ee9caecec80a9df604ed8ba59c0c828548939f974b954003147f22ddeb49bb7b"
    sha256 sonoma:         "20f97a2b00c484efd26b7b184ce7d7165d130f9e01366dfb6a11fa9e6b96f7cb"
    sha256 ventura:        "4af8d55b4d9ce4e4bb3438c53f6530aa00819c3aa3410eaf67716afb3a81151e"
    sha256 monterey:       "24d228b526d5db23c022a523d7458fc90eb14f19c9c2a448904f6987dd6b9485"
    sha256 big_sur:        "6d117a85b5ab93b08e9bd688b52cff3df1a33205debe6d8924524405fe94eedf"
    sha256 x86_64_linux:   "99e9742d73185c98065998c20d97970f7a1044f42d87215745dbbb4a3f697722"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    # TODO: `autoconf`, `automake`, and `libtool` are needed for the libtirpc patch.
    #       Remove when patch is no longer needed.
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libtirpc"
    depends_on "util-linux"

    # Fix finding libtirpc on Linux.
    # https://github.com/OPENDAP/libdap4/pull/228
    patch do
      url "https://github.com/OPENDAP/libdap4/commit/48b44b96faf1ed1e44f118828c3de903fff0a276.patch?full_index=1"
      sha256 "b11c233844691b97d2eab208a49d520ad9d78ce6d14ca52bb5fdad29b5db1f37"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    # Remove `OS.linux? || ` when Linux libtirpc patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" if OS.linux? || build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
