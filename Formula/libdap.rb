class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.6.tar.gz"
  sha256 "35cc7f952d72de4936103e8a95c67ac8f9b855c9211fae73ad065331515cc54a"

  bottle do
    sha256 "41ca77910281671985b9e698d1f6be7fd4943e0b32bf889e39f16ccbb36ab6bc" => :catalina
    sha256 "6aaeaf8fd4959e3cddbb1486d4f1787a6ad8870ad314850311a2c1acedb5382c" => :mojave
    sha256 "7891d895c5a30518351651f6963a6996287c185703487ea6f1ad71de51eb383e" => :high_sierra
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
