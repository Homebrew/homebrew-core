class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.21.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.21.2.tar.gz"
  sha256 "8c2351268e9b8ba2ad288b8b337ce399f79c18e3ffd960803f4ed5de7dda9fa1"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80a3a071b390f9d15f0e84e5f5af17b486dd65f146b3f0e9de59530ad07e650e"
    sha256 cellar: :any,                 arm64_ventura:  "570598cc3c051512b44944d49ec96cfb768a4e4c71cd05a3ed932695faeffbd3"
    sha256 cellar: :any,                 arm64_monterey: "f9b1ae7c259af8f62b4f5872c1db2707ce00f4596c1861e615732a758349f784"
    sha256 cellar: :any,                 sonoma:         "ec1e100e3d94aec5b54cfad86e4caa0e2e8ffb61e6bd2f3f09bec0deeb248e5f"
    sha256 cellar: :any,                 ventura:        "4beeb787ef01b37696ef6172722deddcdd434794e23da865db01f17ff2f554da"
    sha256 cellar: :any,                 monterey:       "89cca3de2e856cd8930e2e7f083ebc820460bb025bcb4c0c300ae4f3f51ff10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66145c8fdf87794050a20e33074ccecd901f28645ee2da8ea2b8418d908249b"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    ENV.deparallelize if OS.linux?

    system "./configure", "--disable-documentation", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end
