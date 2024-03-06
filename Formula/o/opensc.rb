class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.25.0/opensc-0.25.0.tar.gz"
  sha256 "e6d7b66e2a508a377ac9d67aa463025d3c54277227be10bd08872e3407d6622f"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "0c53addcc18c0b635a4be48d57f675835a785db5a2c1491de36737c44a69fada"
    sha256 arm64_ventura:  "92407b17fdec73cb298cb46836cf20e8cccd5a1bd56a026eac831a223ad7d844"
    sha256 arm64_monterey: "786576a6b579cc5519446956f41af276e7bb2229db831f2e942a3b34b1d36f3c"
    sha256 sonoma:         "9fabe901d2f14b93d73758c855fc717fa462af3811fa5673f6adf96ff1a6ecb2"
    sha256 ventura:        "f7f2456f81b07557f9f9c4e138b51fab4b1cbea65d313b205722bfd4fb4ee717"
    sha256 monterey:       "a95f062efec4e638cdb664d64e9335f808fb4c752e1ea126b37e5e990709c098"
    sha256 x86_64_linux:   "7ee7cdd895581deb575482b08771ef8dfe068939605ff043d5b9dab241d5214c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "pcsc-lite"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      The OpenSSH PKCS11 smartcard integration will not work from High Sierra
      onwards. If you need this functionality, unlink this formula, then install
      the OpenSC cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
