class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.23.0/opensc-0.23.0.tar.gz"
  sha256 "a4844a6ea03a522ecf35e49659716dacb6be03f7c010a1a583aaf3eb915ed2e0"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "ed81cd1b4ee92927ea5a489e09a34878c81a924082e101071658e105cf858638"
    sha256 arm64_monterey: "53e0966e77ab894831dc960cedd4efe50bad79d288866877242a476121158969"
    sha256 arm64_big_sur:  "031be42a1b8ea5874e2ae9fea4ca3e2070fe99dd544356c98ea260de4ff4d564"
    sha256 ventura:        "cb74b08610f26136891fc4f039712c29138d2b347b19bf9cbb3b2659b153e2a8"
    sha256 monterey:       "ee4912d3e4173f004b7bf0df0a5ab7293bfa6e36cbe1d5a19b59eac5f1ab5637"
    sha256 big_sur:        "e00651f78485c68d4f435363466a44827f332adcb20ee16fff6f2f17b8fc13e4"
    sha256 x86_64_linux:   "152fb46a04da9f6e492ed3b9c1e0b4672e02fdc6cd98d4f177f646abe3d77ff2"
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
