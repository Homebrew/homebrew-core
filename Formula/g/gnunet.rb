class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.21.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.21.0.tar.gz"
  sha256 "a846eb9f64b5602c6e518badfa32a9ee18d9e66042ad4765e40a936041ca74ad"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40cf19a20f3974bf5942ca41f9f085cb482d40853cf8ff970383d5e97067b151"
    sha256 cellar: :any,                 arm64_ventura:  "2151e8656c7d4876fa53c023be739501edd7d476ff8eb90da065d1ae5cb745e0"
    sha256 cellar: :any,                 arm64_monterey: "ec5970dc331eececf378190acb1aa2dcb4d8f0d173a8a075028189a5af670e19"
    sha256 cellar: :any,                 sonoma:         "e156a18f9dc87ed37ec47ccd4412d060e80a2b8f8638a8c8540a593150434d7d"
    sha256 cellar: :any,                 ventura:        "256236954b09d83a501cfe85023302a3953a2657b00250ce6a6e13bf8e02c8d1"
    sha256 cellar: :any,                 monterey:       "8be873d0ce91f15740297e7fb09499595faf4eb1a39fb36189faf0446c43e6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3295c80b6fcbd45b112d100e515623914dfdea30de759c53726fc9bf8d1de53"
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

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    system "./configure", *std_configure_args, "--disable-documentation"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
