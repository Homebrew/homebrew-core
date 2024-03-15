class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.21.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.21.1.tar.gz"
  sha256 "93e68b3eaca7087273e3d7685fe6ae38b2e8055e4c9e700d360dd4055249785c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a213c40bd6153159eea725821c92e1cabfa6fe4dbc1b2199413f72c10e8eedd6"
    sha256 cellar: :any,                 arm64_ventura:  "7b765e1a360db59e9d14fa367df07e1d8aac06fd180c14c6b2c5032ff3211299"
    sha256 cellar: :any,                 arm64_monterey: "fbd949a468f0c48ccc4369dba16cca9bc964e23b7ca7e5307794591b97a67b20"
    sha256 cellar: :any,                 sonoma:         "cdbe67ce4f80d791274f118334af76ed46f671003b171573885ba0551bd3e8d2"
    sha256 cellar: :any,                 ventura:        "0d681d81e68dcd87f24a02168c511bb5b8e3c30615f96f91c83f72a9efcc28b4"
    sha256 cellar: :any,                 monterey:       "362b295c3cad89609ee42767005060a0688534db99464ecff16e17a66c835ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f588e3700a6e960b388c6129642c53b8d280e7b89a2463b7e8375e711f9c4c"
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
