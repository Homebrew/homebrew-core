class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.21.0-27.tar.gz"
  sha256 "b5b8229d3aa97fea9bba4a0b11b1ee1c6446bd5f7ad2cff591f86064f465eacf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "fc8d72a36ba41654a353b364e6c292d2a89ea948d04f414128b905150d2642cd"
    sha256 arm64_sonoma:   "90d0cfdef210ceec132a9473e3bc8e76c45465048c26812d68028195d0e7f3e5"
    sha256 arm64_ventura:  "cd3169f768274c0125ebee71b9d4ca50712fc2fab103e040ee792b4aea09d2df"
    sha256 arm64_monterey: "e396f29602812683b393da1ae2a4e61da18a5d0586e7cb0012b8d9af22587a4a"
    sha256 sonoma:         "ab456f52c3a3fd0f9bf7e6c212f776e55e59723e39d34b5255f11495e1d8a1da"
    sha256 ventura:        "6649d7822c449061c9fdc3a55900d604e0002541f39d14bf30a5c18ab73a9d32"
    sha256 monterey:       "290966591bfa6f0720ee307a9a1c578449c8b22e1f1930af9591a3539d660a86"
    sha256 x86_64_linux:   "c5a8deb3817eedba2c16b4a380df6539e232a81f2c5d3ce9afc2813f13bd6248"
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
    depends_on "libtirpc"
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    # Versions like `1.2.3-4` with a suffix appear as `1.2.3` in the output, so
    # we have to remove the suffix (if any) from the formula version to match.
    assert_match version.to_s.sub(/-\d+$/, ""), shell_output("#{bin}/dap-config --version")
  end
end
