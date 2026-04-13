class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.27.1/opensc-0.27.1.tar.gz"
  sha256 "976f4a23eaf3397a1a2c3a7aac80bf971a8c3d829c9a79f06145bfaeeae5eca7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a0fc8a7cfee8eb808f3dd85158c0cd45d53b6862166943c4c78b32ba0a00a6a5"
    sha256 arm64_sequoia: "214b7c86658066779e336e95389d52708b72aea0b56cdddf19fd239f46ba5149"
    sha256 arm64_sonoma:  "b4aa3d604ff4ba095b74c24095c513ce0e5c8e9ff9597098b948e187da718bd4"
    sha256 sonoma:        "8b550f5d6a6dc75cf9d04b7275d183a774ac527ef18992a78da86b2361e2ea5c"
    sha256 arm64_linux:   "6425b5a29fa9a7552449200f4fd125d9b90a2d2db4db5f6f7d5465dae07b12de"
    sha256 x86_64_linux:  "dbd088f9f5696f2469be2b0ca5e89d4dbc90575c5fa7fb79b56f20680546f8f4"
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "glib"
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The OpenSSH PKCS11 smartcard integration will not work.
        If you need this functionality, unlink this formula, then install
        the OpenSC cask.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
