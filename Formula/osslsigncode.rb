class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.3.tar.gz"
  sha256 "b842d6d49d423f7e234674678e9a107aa7b77e95b480677b020ee61dd160b2e3"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "04a2c9abec9af3b2aeb89cc603c74454db963ae4f4159829afa411fc7cf79162"
    sha256 cellar: :any,                 arm64_monterey: "4cc44545f4ccfcc7dcad11baa315223e255c25c7799c6f17a3c3f367fd985fd7"
    sha256 cellar: :any,                 arm64_big_sur:  "8e87dd88e7f9822d00f8778893b33785dd41c592a7342c0674b62ebc6e180aa4"
    sha256 cellar: :any,                 ventura:        "4b120f3fccca6e32f8ea2a624efafc8ddc2be1adced699978368701af18846b2"
    sha256 cellar: :any,                 monterey:       "445b6f58e10e78d1ebd8807b5d28d8c974add34745d860c91383a501982ce4af"
    sha256 cellar: :any,                 big_sur:        "3eb048df6eaee844a76b9bc5d010b9c758f445f151d57f607169c18d740b2543"
    sha256 cellar: :any,                 catalina:       "53e53a72b451b4dda993527c67f66e6524ae7d73f58b406e695239718cda13c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb951865556495e94c381859b33bef7fe74c02f4bf4867f4419cd5cf3f1e4cb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version")
  end
end
