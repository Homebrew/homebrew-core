class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.8.tar.gz"
  sha256 "65eb5c8f693cf74d58eece5eaa2e7c3c65f368926b1bffab0cf5b207757b94eb"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3cf1365602c955e21ac619446782b3d273e8d11ed8e3281a59280a18bb53ca58"
    sha256 arm64_big_sur:  "114b06032e3190ea6af91825f75fc44017bdc474c96b4cd88e4f289ed8f03c9b"
    sha256 monterey:       "2958548470c16f762393029b2b4bef0f6d1d74d82120ac33cb30a3d95856958a"
    sha256 big_sur:        "d8e3d1ea27305a3e49c1dc3902f57eec4fd9ae6dfeb102f0dab709b8c8e27e9b"
    sha256 catalina:       "7f6ab80b93c32c6cb09e30af1634f1064bcb2e3bec08f500ac7c78b86fda68dd"
    sha256 mojave:         "433eb5d60160d3ffd96b0e7a8ea215b4b555d9a94001ff6c41c40c13f93e0f42"
    sha256 x86_64_linux:   "1cfc0be83a99c1c2cfcdf04d22b9e8503e99a638f59b3e504b5b0bd5c87927c9"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
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
