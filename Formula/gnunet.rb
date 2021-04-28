class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.14.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.14.1.tar.gz"
  sha256 "4a3205c570c30756f1a8b1ad0f1a63d078a92f0fac8e543471d54f4552da18c2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d2e622cc444972bf0fd15a30922f7f853c066eac83c94b18415fa1547fe1aa2c"
    sha256 cellar: :any, big_sur:       "8f3629373c78f67c8995c3aeb9ec4d27f7576b5f28c1d5b9daac3c8d2ef1796c"
    sha256 cellar: :any, catalina:      "dce4848ff96012a2169bd768d4112dce18dd658f45fa1ab2dfafb4de6886c5fe"
    sha256 cellar: :any, mojave:        "cd3507df5abe3ac3832e61caffc487860e98f05b4a16bb629565c1e84d785c7d"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libsodium"
  depends_on "libunistring"
  depends_on "unbound"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
