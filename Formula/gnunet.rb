class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.15.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.15.3.tar.gz"
  sha256 "d62669a8f41e078eaa220ce77a32f4f3f801e3099357ae8c705498fe73884ec5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0a046eefcb5d04acab22d06539e000cc153753bfcf3a10213146142bfb5554ed"
    sha256 cellar: :any,                 arm64_big_sur:  "e11fd43cdca5151094863572ecda637522293c97882a316ee637ff01d48668d5"
    sha256 cellar: :any,                 monterey:       "afe3184a437f075f2364d6fcfa361f991304ed717f56e3e2e841aee435855944"
    sha256 cellar: :any,                 big_sur:        "ee3b0b12547986dbea1806833d4a0845a4ac092b5653be75b4bb5a2ff257456e"
    sha256 cellar: :any,                 catalina:       "2d6022911c05c414bb187c58077f3e27e4c7cf710a0c7470b1175e2e0ac74788"
    sha256 cellar: :any,                 mojave:         "0990533dacaf2decb9eb3bc20f7d8e21d1d9999670a74c2de483cb893464f114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bb67039350368fce378f5738c23a80429cec01d873b892cce27cfbed8d83012"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libunistring"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
