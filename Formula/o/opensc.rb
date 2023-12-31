class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.24.0/opensc-0.24.0.tar.gz"
  sha256 "24d03c69287291da32a30c4c38a304ad827f56cb85d83619e1f5403ab6480ef8"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "91646fb6d80e62b93a2ada4ae6500bdcbcd95dfa5d718a51402a27fbdacf8aff"
    sha256 arm64_ventura:  "a00b1a47ce1629d2c253348b2d39dc399a277209196c121808db2b3d97c4ea5c"
    sha256 arm64_monterey: "fa6108bbf434e44f9bbadf853961e40d1242cf43ac20659af66401101fd6fe3a"
    sha256 sonoma:         "ee7ab2472705d24b6f3130b3754d3328aedb1a80291023e8e1a352f3f1cbd6e8"
    sha256 ventura:        "c69caffb4dfe0771b13a8b7e956e616340b425c844da55d5d318241679eac6ca"
    sha256 monterey:       "12308a47721171ae81b1cdfc7de312bc04be771730a2c583b719c4477afc7030"
    sha256 x86_64_linux:   "798f2c806bf1206902b54b02eb2595f411263e89abd5e889e0d66dcc9199fc26"
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
