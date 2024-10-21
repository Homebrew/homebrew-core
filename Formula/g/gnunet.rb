class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.22.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.22.1.tar.gz"
  sha256 "816b20b9fbc0e2d2d6a2c9e90183dd008b38c893967e3623e04d75fc4ce0afaa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38e81d8df76fba635bf389fccff77e9c2f131342a3cfd29672baadb296990f0d"
    sha256 cellar: :any,                 arm64_sonoma:  "691d05afb7455a434ba20388300c0c82e3ebabcecb7185eebbc73181f77e388a"
    sha256 cellar: :any,                 arm64_ventura: "59eee8c66dde005d63bd922885757f013896c4a088011a610a6c582332040c2c"
    sha256 cellar: :any,                 sonoma:        "d1da03d426d0b33141f7fe8cd6e67138604ebb60261db08362e40ea9089d7c86"
    sha256 cellar: :any,                 ventura:       "1370abf7fc3a689138a7ab6633e9ced03bb7c24dc51b4bf870868ac37bac65fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01b640ffec7a06a5b63f923ede76ce572fe5f87cccef7660c03817dcf0d405b"
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
