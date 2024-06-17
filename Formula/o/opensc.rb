class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.25.1/opensc-0.25.1.tar.gz"
  sha256 "23cbaae8bd7c8eb589b68c0a961dfb0d02007bea3165a3fc5efe2621d549b37b"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "f0107f0b54f55535c337cb76d6158f68ce02cf1f8f4f10be9a65fac14bf7c5a2"
    sha256 arm64_ventura:  "8c9ed4589ec37481862838d43f0d40954bc333ad3cf4505784e1850188652625"
    sha256 arm64_monterey: "93b0d2c9be69a6f5eb221f0ffe6ab04a80b617fb2a26a5a95a11f3d93dbf41df"
    sha256 sonoma:         "7073bab28896c1dc2a7af797200f91d322873a17b9dcc030154311a8e623064c"
    sha256 ventura:        "860ff6efcbe2328dad7658fe939d64f5e60eed1ac857dfd7e5edded12072a989"
    sha256 monterey:       "5cd706446f087b87f251880290c437200896ac3fd00616cf3c9ef402e6d59c70"
    sha256 x86_64_linux:   "47a739239d0087a0204d56e6e459e7d0acf01df3b4c9e36122e4626d3e1091f9"
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
